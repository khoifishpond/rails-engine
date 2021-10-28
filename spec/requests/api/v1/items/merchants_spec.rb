require 'rails_helper'

describe 'Merchant API' do
  it "can find an item's merchant" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    get "/api/v1/items/#{item.id}/merchant"
    merchant = item.merchant

    merchant_json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.content_type).to eq("application/json")
    expect(merchant_json.class).to eq(Hash)
    expect(merchant_json[:data][:id]).to eq("#{merchant.id}")
    expect(merchant_json[:data][:type]).to eq('merchant')
    expect(merchant_json[:data][:attributes][:name]).to eq(merchant.name)
  end
end