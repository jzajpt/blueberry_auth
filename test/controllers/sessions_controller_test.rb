require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  context "on GET to new" do
    setup { get :new }

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash
    should_render_a_form
  end

  context "on POST to create with valid attributes" do
    setup do
      @user = Factory :user
      User.expects(:authenticate).returns(@user)
      post :create
    end

    should_respond_with :redirect
    should_assign_to :user, :class => User
    should_set_session(:user_id) { @user.id }
    should_set_the_flash_to I18n.t('sessions.create.success')
    should_redirect_to('the root url') { edit_account_url }
  end

  context "on POST to create with invalid attributes" do
    setup do
      User.expects(:authenticate).returns(nil)
      post :create
    end

    should_respond_with :success
    should_render_template :new
    should_set_the_flash_to I18n.t('sessions.create.invalid_credentials')
  end

  context "on DELETE to destroy" do
    setup do
      @user = Factory :user
      @request.session[:user_id] = @user.id
      delete :destroy
    end

    should_respond_with :redirect
    should_set_the_flash_to I18n.t('sessions.destroy.success')

    should "clear user_id from session" do
      assert_nil session[:user_id]
    end
  end
end
