require 'rails_helper'

describe Filterable do
  it "#filter" do
    m1, m2, m3 = create_list(:merchant, 3)

    expect(Merchant.filter({name: "#{m1.name}"})).to eq([m1])
  end
end