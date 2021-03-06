class Invoice < ApplicationRecord
  before_validation :add_invoice_number, on: :create

  belongs_to :business
  belongs_to :contact
  has_many :items, dependent: :nullify, inverse_of: :invoice
  has_many :payments, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc { |attributes| attributes['name'].blank? }
  validates :date, :expiration_date, presence: true
  mount_uploader :signature, LogoUploader
  monetize :amount_paid_cents
  monetize :amount_retained_cents

  def formated_number
    format("%03d", number)
  end

  def pdf_file_name
    "#{formated_number} FV #{contact.name} #{date}"
  end

  def name
    "Factura de Venta #{formated_number}"
  end

  def status
    if debt.zero?
      "Cobrada"
    else
      "Por Cobrar"
    end
  end

  def formated_date
    date.strftime("%d/%m/%Y")
  end

  def formated_expiration_date
    expiration_date.strftime("%d/%m/%Y")
  end

  def items_gross_subtotal
    sum = 0
    items.each do |item|
      sum += item.gross_total
    end
    return sum
  end

  def items_discount_subtotal
    sum = 0
    items.each do |item|
      sum -= item.discount_amount
    end
    return sum
  end

  def items_vat_subtotal
    sum = 0
    items.each do |item|
      sum += item.vat_amount
    end
    return sum
  end

  def items_net_subtotal
    items_gross_subtotal + items_discount_subtotal
  end

  def total
    items_net_subtotal + items_vat_subtotal
  end

  def amount_paid_cents
    payments.sum(:amount_cents)
  end

  def amount_retained_cents
    payments.sum(:retention_cents)
  end

  def debt
    total - amount_paid - amount_retained
  end

  def resolution_number?(business)
    resolution_number || business.invoice_resolution_number
  end

  def terms_and_conditions?(business)
    terms_and_conditions || business.invoice_terms_and_conditions
  end

  def notes?(business)
    notes || business.invoice_notes
  end

  def term
    (date..expiration_date).count
  end

  def signature?
    return unless signature.file || business.signature.file

    signature.file ? signature : business.signature
  end

  private

  def add_invoice_number
    self.number = business.invoices.size + 1
  end
end
