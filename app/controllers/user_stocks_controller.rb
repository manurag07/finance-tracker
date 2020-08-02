class UserStocksController < ApplicationController

  def create
    @stock = current_user.stocks.find_by_ticker(params[:ticker])
    unless @stock.present?
      @stock = Stock.new_lookup(params[:ticker])
      if @stock.save
        @user_stocks = UserStock.create(user: current_user, stock: @stock)
        flash[:notice] = 'Company saved sucessfully'
      else
        flash[:alert] = 'Something went wrong'
      end
    end
    redirect_to my_portfolio_path
  end

  def destroy
    stock = UserStock.where(user_id: current_user.id, stock_id: params[:id]).first
    if stock.destroy
      flash[:notice] = 'You are sucessfully deleted the stock'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to my_portfolio_path
  end
end
