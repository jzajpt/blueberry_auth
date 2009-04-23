class UsersController < ApplicationController
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @user.save!
    redirect_to_with_success_flash root_url 
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end
end
