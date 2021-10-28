class MerchantNameRevenueSerializer
  include JSONAPI::Serializer
  set_type :merchant_name_revenue
  attributes :name, :revenue
end