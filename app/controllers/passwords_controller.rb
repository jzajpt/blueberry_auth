class PasswordsController < ApplicationController
  verify :params => [:user_id, :token], :only => [:edit, :update]

  before_filter :find_user_with_token, :only => [:edit, :update]

  # GET /password/new
  def new
  end

  # GET /users/:id/password/edit
  def edit
  end

  # POST /password
  def create
    @user = User.find_by_email!(params[:email])
    @user.forgot_password!
    AuthMailer.deliver_password_change @user
    redirect_to_with_success_flash root_url
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('passwords.create.invalid_email')
    render 'new'
  end

  # PUT /users/:id/password
  def update
    if @user.set_new_password(params[:user][:password], params[:user][:password_confirmation])
      redirect_to_with_success_flash new_session_url
    else
      render 'edit'
    end
  end

  protected

  def find_user_with_token
    @user = User.find_by_id_and_token!(params[:user_id], params[:token])
  end
end
