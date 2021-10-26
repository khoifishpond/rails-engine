class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: MerchantSerializer.new(search(params).first)
  end

  def index
    render json: MerchantSerializer.new(search(params))
  end

  private

  def search(params)
    Merchant.filter(params.slice(:name, :id))
  end
end