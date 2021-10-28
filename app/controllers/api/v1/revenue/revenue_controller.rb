class Api::V1::Revenue::RevenueController < ApplicationController
  def index
    merchants = Merchant.most_revenue(params[:quantity])

    if params[:quantity].to_i <= Merchant.count && params[:quantity].to_i.positive?
      render json: MerchantNameRevenueSerializer.new(merchants)
    elsif params[:quantity].to_i >= Merchant.count && params[:quantity].to_i.positive?
      render json: MerchantNameRevenueSerializer.new(merchants)
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end