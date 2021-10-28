class Api::V1::RevenueController < ApplicationController
  def index
    render json: RevenueSerializer.new(RevenueFacade.total_revenue(params[:start], params[:end]))
  end
end