class Merchant < ApplicationRecord
  include Filterable, Paginatable

  validates :name, presence: true
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices

  scope :filter_by_name, -> (name) { where('LOWER(name) LIKE ?', "%#{name.downcase}%") }
  scope :filter_by_id, -> (id) { where(id: id) }
  scope :filter_by_created_at, -> (created_at) { where('DATE(created_at) = ?', created_at.to_s) }
  scope :filter_by_updated_at, -> (updated_at) { where('DATE(updated_at) = ?', updated_at.to_s) }

  def self.most_revenue(quantity = 5)
    joins(invoices: %i[invoice_items transactions])
      .select('merchants.*, SUM(invoice_items.quantity*invoice_items.unit_price) AS revenue')
      .where("transactions.result = 'success' AND invoices.status = 'shipped'")
      .group('merchants.id')
      .order('revenue DESC')
      .limit(quantity)
  end

  def self.most_items(quantity = 5)
    joins(invoices: %i[invoice_items transactions])
      .select('merchants.*, sum(invoice_items.quantity) AS items_sold')
      .where("transactions.result='success' AND invoices.status='shipped'")
      .group('merchants.id')
      .order('items_sold DESC')
      .limit(quantity)
  end

  def self.total_revenue(start_date, end_date)
    Invoice
      .joins(:invoice_items, :transactions)
      .where(status: :shipped, created_at: Date.parse(start_date).beginning_of_day..Date.parse(end_date).end_of_day)
      .where("transactions.result='success' AND invoices.status='shipped'")
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def revenue
    Invoice
      .joins(:transactions)
      .joins(:invoice_items)
      .where("transactions.result = 'success' AND invoices.status = 'shipped'")
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end