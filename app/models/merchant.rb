class Merchant < ApplicationRecord
  include Filterable, Paginatable

  validates :name, presence: true
  has_many :items, dependent: :destroy

  scope :filter_by_name, -> (name) { where('lower(name) LIKE ?', "%#{name.downcase}%") }
  scope :filter_by_id, -> (id) { where(id: id) }
end