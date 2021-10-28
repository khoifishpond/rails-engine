class Item < ApplicationRecord
  include Filterable, Paginatable

  validates :name, :description, :unit_price, presence: true
  belongs_to :merchant

  scope :filter_by_name, -> (name) { where('LOWER(name) LIKE ?', "%#{name.downcase}%") }
  scope :filter_by_description, -> (description) { where('LOWER(description) LIKE ?', "%#{description.downcase}%") }
  scope :filter_by_unit_price, -> (unit_price) { where(unit_price: unit_price) }
  scope :filter_by_id, -> (id) { where(id: id) }
  scope :filter_by_merchant_id, -> (merchant_id) { where(merchant_id: merchant_id) }
end