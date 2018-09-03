class Building < ApplicationRecord
  belongs_to :user
  has_many :properties, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :owners, dependent: :destroy
  has_many :bills, through: :properties
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user }

  def building_coeficients_sum
    properties.sum(:building_coeficient)
  end

  def area_sum
    properties.sum(:area)
  end
end
