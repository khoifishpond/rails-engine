class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end

  def most_items
    merchants = Merchant.most_items(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end
end