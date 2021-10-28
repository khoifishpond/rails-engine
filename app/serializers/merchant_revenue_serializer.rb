class MerchantRevenueSerializer
  include JSONAPI::Serializer
  set_type :merchant_revenue
  attribute :revenue
end