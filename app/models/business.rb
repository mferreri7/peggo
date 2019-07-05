class Business < ApplicationRecord
  INVOICE_TERMS_AND_CONDITIONS = "1. Esta factura de venta se asimila en todos sus efectos legales a una letra de cambio según el artículo No. 671 y S.S. 772-774 del código de comercio.\n2. En caso de mora se causara el interés autorizado por la ley."
  INVOICE_NOTES = "Pagos por consignación o transferencia bancaria a la Cuenta de Ahorros BANCOLOMBIA a nombre de SCUAD S.A.S No. 02900017858.\nFavor anunciar su pago al correo electrónico nosotros@scuad.co"
  INVOICE_RESOLUTION_NUMBER = "Resolución Autorización por Computador DIAN N° 18762013589371 del 20/03/2019 del 1 HASTA 500 - Vigencia 24 Meses"

  belongs_to :user
  has_many :expenses, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :items, through: :invoices

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }

  mount_uploader :logo, LogoUploader
end
