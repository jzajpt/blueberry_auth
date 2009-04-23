class SessionsController < ApplicationController
  # GET /session/new
  def new
  end

  # POST /session
  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      sign_in_user @user
      flash[:notice] = t('sessions.create.success')
      redirect_back_or_to edit_account_url
    else
      flash[:error] = t('sessions.create.invalid_credentials')
      render 'new'
    end
  end

  # DELETE /session
  def destroy
    sign_out_user
    flash[:notice] = t('sessions.destroy.success')
    redirect_to root_url
  end
end