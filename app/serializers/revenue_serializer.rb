class RevenueSerializer
  include JSONAPI::Serializer
  attribute :revenue
  set_id 'nil?'
end