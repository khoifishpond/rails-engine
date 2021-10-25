require 'rails_helper'

describe 'get /api/v1/merchants' do
  it 'gets all merchants data' do
    create_list(:merchant, 20)

    per_page = 5
    page = 2
    get "/api/v1/merchants?per_page=#{per_page}&page=#{page}"

    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    expect(merchants).to be_a(Hash)
    expect(merchants).to have_key(:data)

    expect(merchants[:data]).to be_an(Array)
    expect(merchants[:data].count).to eq(per_page)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can find a merchant' do
    id = create(:merchant).id

    get api_v1_merchant_path(id)

    merchant = JSON.parse(response.body, symbolize_names: true)
    merch = Merchant.find(id)

    expect(response).to be_successful

    expect(merchant).to be_a(Hash)
    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a(Hash)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq("#{id}")
    
    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to eq('merchant')
    
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to eq(merch.name)
  end

  it 'can find all items from a merchant' do
    merchant = create(:merchant)
    create_list(:item, 5, merchant: merchant)
    
    get api_v1_merchant_items_path(merchant)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    expect(items).to be_a(Hash)
    expect(items).to have_key(:data)

    expect(items[:data]).to be_an(Array)
    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

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
end