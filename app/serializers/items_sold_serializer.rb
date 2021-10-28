class ItemsSoldSerializer
  include JSONAPI::Serializer
  attribute :name

  attribute :count do |resource|
    resource.items_sold
  end
end