class AccountsController < ApplicationController
  before_filter :authenticate

  # GET /account/edit
  def edit
    @user = current_user
  end

  # PUT /account
  def update
    @user = current_user
    @user.update_attributes!(params[:user])
    redirect_to_with_success_flash root_url
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end
end
