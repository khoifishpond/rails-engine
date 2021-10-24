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
    expect(merchants[:data].count).to eq(5)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

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
end