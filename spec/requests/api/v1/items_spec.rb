require 'rails_helper'

describe 'get /api/v1/items' do
  it 'gets all items data' do
    merchants = create_list(:merchant, 2)
    create_list(:item, 10, merchant: merchants.first)
    create_list(:item, 5, merchant: merchants.last)

    per_page = 3
    page = 4
    get "/api/v1/items?per_page=#{per_page}&page=#{page}"

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    
    expect(items).to be_a(Hash)
    expect(items).to have_key(:data)
    
    expect(items[:data]).to be_an(Array)
    expect(items[:data].count).to eq(per_page)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'can find an item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get api_v1_item_path(item.id)

    item_json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item_json).to be_a(Hash)
    expect(item_json).to have_key(:data)
    expect(item_json[:data]).to be_a(Hash)
    
    expect(item_json[:data]).to have_key(:id)
    expect(item_json[:data][:id]).to eq("#{item.id}")
    
    expect(item_json[:data]).to have_key(:type)
    expect(item_json[:data][:type]).to eq('item')
    
    expect(item_json[:data]).to have_key(:attributes)
    expect(item_json[:data][:attributes]).to be_a(Hash)

    expect(item_json[:data][:attributes]).to have_key(:name)
    expect(item_json[:data][:attributes][:name]).to eq(item.name)

    expect(item_json[:data][:attributes]).to have_key(:description)
    expect(item_json[:data][:attributes][:description]).to eq(item.description)

    expect(item_json[:data][:attributes]).to have_key(:unit_price)
    expect(item_json[:data][:attributes][:unit_price]).to eq(item.unit_price)
  end

  it 'can create an item' do
    merchant = create(:merchant)
    item_params = {
      name: 'toilet',
      description: 'poop, pee, vomit destroyer',
      unit_price: 299.99,
      merchant_id: merchant.id
    }

    post '/api/v1/items', params: item_params

    item = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    expect(item).to be_a(Hash)
    expect(item).to have_key(:data)
    expect(item[:data]).to be_a(Hash)
    
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    
    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to eq('item')
    
    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a(Hash)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to eq(item_params[:name])

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to eq(item_params[:description])

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to eq(item_params[:unit_price])
  end

  it 'can update an item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    old_price = item.unit_price
    item_params = {unit_price: 199.99}
    
    patch "/api/v1/items/#{item.id}", params: item_params

    updated_item = Item.find(item.id)

    item_json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item_json).to be_a(Hash)
    expect(item_json).to have_key(:data)
    expect(item_json[:data]).to be_a(Hash)
    
    expect(item_json[:data]).to have_key(:id)
    expect(item_json[:data][:id]).to be_a(String)
    
    expect(item_json[:data]).to have_key(:type)
    expect(item_json[:data][:type]).to eq('item')
    
    expect(item_json[:data]).to have_key(:attributes)
    expect(item_json[:data][:attributes]).to be_a(Hash)

    expect(item_json[:data][:attributes]).to have_key(:name)
    expect(item_json[:data][:attributes][:name]).to eq(updated_item.name)

    expect(item_json[:data][:attributes]).to have_key(:description)
    expect(item_json[:data][:attributes][:description]).to eq(updated_item.description)

    expect(item_json[:data][:attributes]).to have_key(:unit_price)
    expect(item_json[:data][:attributes][:unit_price]).to eq(updated_item.unit_price)

    expect(updated_item.unit_price).to_not eq(old_price)
    expect(updated_item.unit_price).to eq(item_params[:unit_price])
  end

  it 'can delete an item' do
    merchant = create(:merchant)
    items = create_list(:item, 3, merchant: merchant)

    expect(Item.count).to eq(3)

    delete "/api/v1/items/#{items.first.id}"

    expect(Item.count).to eq(2)
  end
end