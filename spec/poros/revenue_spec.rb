require 'rails_helper'

describe 'Revenue' do
  it "is initialize with a revenue" do
    rev = Revenue.new(10)
    expect(rev.revenue).to eq(10)
  end
end