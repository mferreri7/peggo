class Bill < ApplicationRecord
  after_create :add_property_monthly_fee
  enum status: ["Pagada", "Pendiente"]

  belongs_to :share
  has_many :concepts, dependent: :destroy

  validates :status, :period, presence: true

  def add_property_monthly_fee
    concept = Concept.new(
      amount: share.bill_payment,
      description: "Cuota administración #{share.owner.building.name} #{share.property.full_name}"
    )
    concepts << concept
  end
end
