require 'rails_helper'

describe Paginatable do
  it "#paginate" do
    create_list(:merchant, 10)
    per_page = 5
    page = 2
    merchants = Merchant.paginate(page, per_page)

    expect(merchants.count).to eq(per_page)
  end
end