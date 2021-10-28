require 'rails_helper'

describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe 'most_revenue  ' do
    it "#revenue" do
      m1, m2, m3 = create_list(:merchant, 3)
      it1 = create(:item, merchant_id: m1.id)
      it2 = create(:item, merchant_id: m2.id)
      it3 = create(:item, merchant_id: m3.id)
      in1 = create(:invoice, merchant_id: m1.id, status: 'shipped')
      in2 = create(:invoice, merchant_id: m2.id, status: 'shipped')
      in3 = create(:invoice, merchant_id: m3.id, status: 'shipped')
      ii1 = create(:invoice_item, invoice_id: in1.id, item_id: it1.id, quantity: 1, unit_price: 10 )
      ii2 = create(:invoice_item, invoice_id: in2.id, item_id: it2.id, quantity: 2, unit_price: 20 )
      ii3 = create(:invoice_item, invoice_id: in3.id, item_id: it3.id, quantity: 3, unit_price: 30 )
      t1 = create(:transaction, invoice_id: in1.id, result: 'success', created_at: '2012-03-25 14:53:59 UTC' )
      t2 = create(:transaction, invoice_id: in2.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )
      t3 = create(:transaction, invoice_id: in3.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )

      expect(Merchant.most_revenue(1)).to eq([m3])
    end

    it "#most_items" do
      m1, m2, m3 = create_list(:merchant, 3)
      it1 = create(:item, merchant_id: m1.id)
      it2 = create(:item, merchant_id: m2.id)
      it3 = create(:item, merchant_id: m3.id)
      in1 = create(:invoice, merchant_id: m1.id, status: 'shipped')
      in2 = create(:invoice, merchant_id: m2.id, status: 'shipped')
      in3 = create(:invoice, merchant_id: m3.id, status: 'shipped')
      ii1 = create(:invoice_item, invoice_id: in1.id, item_id: it1.id, quantity: 1, unit_price: 10 )
      ii2 = create(:invoice_item, invoice_id: in2.id, item_id: it2.id, quantity: 2, unit_price: 20 )
      ii3 = create(:invoice_item, invoice_id: in3.id, item_id: it3.id, quantity: 3, unit_price: 30 )
      t1 = create(:transaction, invoice_id: in1.id, result: 'success', created_at: '2012-03-25 14:53:59 UTC' )
      t2 = create(:transaction, invoice_id: in2.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )
      t3 = create(:transaction, invoice_id: in3.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )

      expect(Merchant.most_items(1)).to eq([m3])
    end

    it "#revenue" do
      merchants = create_list(:merchant, 2)
      merchant = merchants.first
      item_1 = create(:item, merchant_id: merchants.first.id)
      item_2 = create(:item, merchant_id: merchants.first.id)
      items_2 = create_list(:item, 2, merchant_id: merchants.last.id)
      invoices = create_list(:invoice, 2, merchant_id: merchants.first.id)
      ii1 = create(:invoice_item, invoice_id: invoices.first.id, item_id: item_1.id)
      ii2 = create(:invoice_item, invoice_id: invoices.last.id, item_id: item_2.id)
      create(:transaction, invoice_id: invoices.first.id, result: 'success')
      create(:transaction, invoice_id: invoices.last.id, result: 'success')
      expected = (ii1.quantity * ii1.unit_price) + (ii2.quantity * ii2.unit_price)

      expect(merchant.revenue).to eq(expected)
    end

    it "#total_revenue" do
      m1, m2, m3, m4, m5, m6, m7 = create_list(:merchant, 7)

      it1 = create(:item, merchant_id: m1.id)
      it2 = create(:item, merchant_id: m2.id)
      it3 = create(:item, merchant_id: m3.id)
      it4 = create(:item, merchant_id: m4.id)
      it5 = create(:item, merchant_id: m5.id)
      it6 = create(:item, merchant_id: m6.id)
      it7 = create(:item, merchant_id: m7.id)

      in1 = create(:invoice, merchant_id: m1.id, status: 'shipped', created_at: '2012-03-25 14:53:59 UTC')
      in2 = create(:invoice, merchant_id: m2.id, status: 'shipped', created_at: '2012-03-26 14:53:59 UTC')
      in3 = create(:invoice, merchant_id: m3.id, status: 'shipped', created_at: '2012-03-26 14:53:59 UTC')
      in4 = create(:invoice, merchant_id: m4.id, status: 'shipped', created_at: '2012-03-27 14:53:59 UTC')
      in5 = create(:invoice, merchant_id: m5.id, status: 'shipped', created_at: '2012-03-27 14:53:59 UTC')
      in6 = create(:invoice, merchant_id: m6.id, status: 'packaged', created_at: '2012-03-27 14:53:59 UTC')
      in7 = create(:invoice, merchant_id: m7.id, status: 'shipped', created_at: '2012-03-28 14:53:59 UTC')

      ii1 = create(:invoice_item, invoice_id: in1.id, item_id: it1.id, quantity: 1, unit_price: 10, created_at: '2012-03-25 14:53:59 UTC' )
      ii2 = create(:invoice_item, invoice_id: in2.id, item_id: it2.id, quantity: 2, unit_price: 20, created_at: '2012-03-26 14:53:59 UTC' )
      ii3 = create(:invoice_item, invoice_id: in3.id, item_id: it3.id, quantity: 3, unit_price: 30, created_at: '2012-03-26 14:53:59 UTC' )
      ii4 = create(:invoice_item, invoice_id: in4.id, item_id: it4.id, quantity: 4, unit_price: 40, created_at: '2012-03-27 14:53:59 UTC' )
      ii5 = create(:invoice_item, invoice_id: in5.id, item_id: it5.id, quantity: 5, unit_price: 50, created_at: '2012-03-27 14:53:59 UTC' )
      ii6 = create(:invoice_item, invoice_id: in6.id, item_id: it6.id, quantity: 6, unit_price: 60, created_at: '2012-03-27 14:53:59 UTC' )
      ii7 = create(:invoice_item, invoice_id: in7.id, item_id: it7.id, quantity: 7, unit_price: 70, created_at: '2012-03-28 14:53:59 UTC' )

      t1 = create(:transaction, invoice_id: in1.id, result: 'success', created_at: '2012-03-25 14:53:59 UTC' )
      t2 = create(:transaction, invoice_id: in2.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )
      t3 = create(:transaction, invoice_id: in3.id, result: 'success', created_at: '2012-03-26 14:53:59 UTC' )
      t4 = create(:transaction, invoice_id: in4.id, result: 'success', created_at: '2012-03-27 14:53:59 UTC' )
      t5 = create(:transaction, invoice_id: in5.id, result: 'success', created_at: '2012-03-27 14:53:59 UTC' )
      t6 = create(:transaction, invoice_id: in6.id, result: 'success', created_at: '2012-03-27 14:53:59 UTC' )
      t7 = create(:transaction, invoice_id: in7.id, result: 'failed', created_at: '2012-03-28 14:53:59 UTC' )

      rev1 = ii1.quantity * ii1.unit_price
      rev2 = ii2.quantity * ii2.unit_price
      rev3 = ii3.quantity * ii3.unit_price
      rev4 = ii4.quantity * ii4.unit_price
      rev5 = ii5.quantity * ii5.unit_price
      expected = rev1 + rev2 + rev3 + rev4 + rev5

      expect(Merchant.total_revenue("2012-03-25", "2012-03-28")).to eq(550.0)
    end
  end
end