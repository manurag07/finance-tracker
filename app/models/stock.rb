# frozen_string_literal: true

class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_lookup(symbol)
    client = setup_connection
    begin
      new(ticker: symbol, name: client.company(symbol).company_name,
          last_price: client.price(symbol))
    rescue StandardError
      nil
    end
  end

  def self.setup_connection
    IEX::Api::Client.new(
      publishable_token: 'Tpk_2fff5ee7b46e477ea40d6fbf63db866a',
      secret_token: 'Tsk_a34dde5a7a49430ca6e6996de04801f9',
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
  end
end
