require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  context "on GET to new" do
    setup { get :new }

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
    should_render_a_form
  end

  context "on GET to edit with valid email and token" do
    setup do
      @user = Factory :user
      @user.forgot_password!
      get :edit, :user_id => @user.id, :token => @user.token
    end

    should_respond_with :success
    should_render_template :edit
    should_assign_to(:user) { @user }
    should_not_set_the_flash
    should_render_a_form
  end

  context "on POST to create with valid email" do
    setup do
      @user = Factory :user
      User.any_instance.expects(:forgot_password!)
      post :create, :email => @user.email
    end

    should_respond_with :redirect
    should_assign_to(:user) { @user }
    should_set_the_flash_to I18n.t('passwords.create.success')

    should "sent email" do
      assert_sent_email
    end
  end

  context "on POST to create with unknown email" do
    setup do
      User.any_instance.expects(:forgot_password!).never
      AuthMailer.expects(:deliver_password_change).never
      post :create, :email => 'unknown@example.com'
    end

    should_respond_with :success
    should_render_template :new
    should_set_the_flash_to I18n.t('passwords.create.invalid_email')
  end

  context "on POST to update with valid passwords" do
    setup do
      @user = Factory :user
      @user.forgot_password!
      User.any_instance.stubs(:set_new_password).returns(true)
      put :update, :user_id => @user.id, :token => @user.token, :user => {}
    end

    should_respond_with :redirect
    should_assign_to(:user) { @user }
    should_set_the_flash_to I18n.t('passwords.update.success')
  end

  context "on POST to update with non matching passwords" do
    setup do
      @user = Factory :user
      @user.forgot_password!
      User.any_instance.stubs(:set_new_password).returns(false)
      put :update, :user_id => @user.id, :token => @user.token, :user => {}
    end

    should_respond_with :success
    should_assign_to(:user) { @user }
    should_render_template :edit
  end
end