# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  validates :first_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def present_in_db?(ticker)
    stock = Stock.check_db(ticker)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    (user_stocks.count < 10)
  end

  def can_track_stock?(ticker)
    under_stock_limit? && !present_in_db?(ticker)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name

    'Anonymos'
  end

  def self.search(params)
    params.strip!
    to_send_name = (first_name_matches(params) + last_name_matches(params) +
                                                  email_matches(params)).uniq
    nil unless to_send_name
    to_send_name
  end

  def self.first_name_matches(params)
    matches('first_name', params)
  end

  def self.last_name_matches(params)
    matches('last_name', params)
  end

  def self.email_matches(params)
    matches('email', params)
  end

  def self.matches(field, params)
    where("#{field} like ?", "%#{params}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == id }
  end

  def not_friend_with?(friend_id)
    !friends.where(id: friend_id).exists?
  end
end
