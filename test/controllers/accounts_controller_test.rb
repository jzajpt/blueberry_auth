require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  context "on GET to edit" do
    setup do
      @user = Factory :user
      @request.session[:user_id] = @user.id
      get :edit
    end

    should_respond_with :success
    should_render_template :edit
    should_assign_to(:user) { @user }
    should_not_set_the_flash
    should_render_a_form
  end

  context "on PUT to update with valid attributes" do
    setup do
      @user = Factory :user
      @request.session[:user_id] = @user.id
      User.any_instance.expects(:update_attributes!).returns(true)
      put :update
    end

    should_respond_with :redirect
    should_assign_to(:user) { @user }
    should_set_the_flash_to I18n.t('accounts.update.success')
  end

  context "on PUT to update with invalid attributes" do
    setup do
      @user = Factory :user
      @request.session[:user_id] = @user.id
      User.any_instance.expects(:update_attributes!).raises(
        ActiveRecord::RecordInvalid.new(@user))
      put :update
    end

    should_respond_with :success
    should_render_template :edit
    should_assign_to(:user) { @user }
    should_not_set_the_flash
  end
end