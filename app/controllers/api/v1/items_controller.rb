class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.paginate(page = params[:page].to_i, per_page = params[:per_page].to_i)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    item = Item.update(params[:id], item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    Item.delete(params[:id])
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end