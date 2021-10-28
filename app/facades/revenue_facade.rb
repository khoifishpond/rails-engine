class RevenueFacade
  def self.revenue(amount)
    Revenue.new(amount)
  end

  def self.total_revenue(start_date, end_date)
    Revenue.new(Merchant.total_revenue(start_date, end_date))
  end
end