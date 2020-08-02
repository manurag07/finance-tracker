class UsersController < ApplicationController
  def my_portfolio
    @stocks = current_user.stocks
    @user = current_user
  end

  def friends_stock
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @stocks = @user.stocks
  end

  def search
    if params[:friend_name].present?
      @friends = User.search(params[:friend_name])
      @friends = current_user.except_current_user(@friends)
      if @friends
        respond_to do |format|
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldn't any find user"
          format.js { render partial: 'users/friend_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'Please enter a friend name or email to search'
        format.js { render partial: 'users/friend_result' }
      end
    end
  end

  def create_friend
    @friend = current_user.friendships.build(friend_id: params[:id])
    if @friend.save
      flash[:notice] = 'Successfully friend'
    else
      flash.now[:alert] = 'Something went wrong'
    end
    redirect_to my_friend_path
  end

  def destroy_friend
    friend = Friendship.where(user_id: current_user.id, friend_id: params[:id]).first
    if friend.destroy
      flash[:notice] = 'Friendsip deleted sucessfully'
    else
      flash[:alert] = 'Something went wrong'
    end
    redirect_to my_friend_path
  end
end
