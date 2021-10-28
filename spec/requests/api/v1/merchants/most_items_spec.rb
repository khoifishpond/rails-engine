require 'rails_helper'

describe 'Most items sold of a variable number of merchants' do
  before(:each) do
    @m1, @m2, @m3, @m4, @m5, @m6, @m7 = create_list(:merchant, 7)

    @it1 = create(:item, merchant_id: @m1.id)
    @it2 = create(:item, merchant_id: @m2.id)
    @it3 = create(:item, merchant_id: @m3.id)
    @it4 = create(:item, merchant_id: @m4.id)
    @it5 = create(:item, merchant_id: @m5.id)
    @it6 = create(:item, merchant_id: @m6.id)
    @it7 = create(:item, merchant_id: @m7.id)

    @in1 = create(:invoice, merchant_id: @m1.id, status: 'shipped')
    @in2 = create(:invoice, merchant_id: @m2.id, status: 'shipped')
    @in3 = create(:invoice, merchant_id: @m3.id, status: 'shipped')
    @in4 = create(:invoice, merchant_id: @m4.id, status: 'shipped')
    @in5 = create(:invoice, merchant_id: @m5.id, status: 'shipped')
    @in6 = create(:invoice, merchant_id: @m6.id, status: 'packaged')
    @in7 = create(:invoice, merchant_id: @m7.id, status: 'shipped')

    @ii1 = create(:invoice_item, invoice_id: @in1.id, item_id: @it1.id, quantity: 1, unit_price: 10 )
    @ii2 = create(:invoice_item, invoice_id: @in2.id, item_id: @it2.id, quantity: 2, unit_price: 20 )
    @ii3 = create(:invoice_item, invoice_id: @in3.id, item_id: @it3.id, quantity: 3, unit_price: 30 )
    @ii4 = create(:invoice_item, invoice_id: @in4.id, item_id: @it4.id, quantity: 4, unit_price: 40 )
    @ii5 = create(:invoice_item, invoice_id: @in5.id, item_id: @it5.id, quantity: 5, unit_price: 50 )
    @ii6 = create(:invoice_item, invoice_id: @in6.id, item_id: @it6.id, quantity: 6, unit_price: 60 )
    @ii7 = create(:invoice_item, invoice_id: @in7.id, item_id: @it7.id, quantity: 7, unit_price: 70 )

    @t1 = create(:transaction, invoice_id: @in1.id, result: 'success', created_at: '2012-03-25 14:53:59 UTC' )
    @t2 = create(:transaction, invoice_id: @in2.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )
    @t3 = create(:transaction, invoice_id: @in3.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )
    @t4 = create(:transaction, invoice_id: @in4.id, result: 'success', created_at: '2012-03-27 14:53:59 UTC' )
    @t5 = create(:transaction, invoice_id: @in5.id, result: 'success', created_at: '2012-03-27 14:53:59 UTC' )
    @t6 = create(:transaction, invoice_id: @in6.id, result: 'success', created_at: '2012-03-27 14:53:59 UTC' )
    @t7 = create(:transaction, invoice_id: @in7.id, result: 'failed', created_at: '2012-03-28 14:53:59 UTC' )
  end

  it "can return the top three merchants ranked by total number of items sold" do
    get "/api/v1/merchants/most_items", params: { :quantity => 3 }

    most_items_json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(most_items_json[:data][0]).to have_key(:id)
    expect(most_items_json[:data][0]).to have_key(:type)
    expect(most_items_json[:data][0]).to have_key(:attributes)
    expect(most_items_json[:data][0][:attributes]).to have_key(:name)
    expect(most_items_json[:data][0][:attributes][:name]).to eq(@m5.name)
    expect(most_items_json[:data][1][:attributes][:name]).to eq(@m4.name)
    expect(most_items_json[:data][2][:attributes][:name]).to eq(@m3.name)
    expect(most_items_json[:data][0][:attributes][:name]).to_not eq(@m6.name)
    expect(most_items_json[:data][0][:attributes][:name]).to_not eq(@m7.name)
  end

  it "will just return all merchants if quantity is greated than amount in db" do
    get "/api/v1/merchants/most_items", params: { :quantity => 10 }

    most_items_json = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(most_items_json[:data][0][:attributes][:name]).to eq(@m5.name)
    expect(most_items_json[:data][1][:attributes][:name]).to eq(@m4.name)
    expect(most_items_json[:data][2][:attributes][:name]).to eq(@m3.name)
    expect(most_items_json[:data][3][:attributes][:name]).to eq(@m2.name)
    expect(most_items_json[:data][4][:attributes][:name]).to eq(@m1.name)
    expect(most_items_json[:data][0][:attributes][:name]).to_not eq(@m6.name)
    expect(most_items_json[:data][0][:attributes][:name]).to_not eq(@m7.name)
  end
end