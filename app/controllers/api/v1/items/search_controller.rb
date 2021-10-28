class Api::V1::Items::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(search(params).first)
  end

  def index
    render json: ItemSerializer.new(search(params))
  end

  private

  def search(params)
    Item.filter(params.slice(:name, :description, :unit_price, :id, :merchant_id))
  end
end