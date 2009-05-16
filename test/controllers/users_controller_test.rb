require 'test_helper'

class Evergreen::UsersControllerTest < ActionController::TestCase
  context "on GET to new" do
    setup { get :new }

    should_respond_with :success
    should_render_template :new
    should_assign_to :user, :class => User
    should_not_set_the_flash
    should_render_a_form
    should_not_have_missing_translations
  end

  context "on POST to create with valid attributes" do
    setup do
      User.any_instance.expects(:save!).returns(true)
      post :create
    end

    should_respond_with :redirect
    should_assign_to :user, :class => User
    should_set_the_flash_to I18n.t('evergreen.users.create.success')
    should_redirect_to('the root url') { root_url }
  end

  context "on POST to create with invalid attributes" do
    setup do
      User.any_instance.expects(:save!).raises(
        ActiveRecord::RecordInvalid.new(User.new))
      post :create
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :user, :class => User
    should_not_set_the_flash
    should_not_have_missing_translations
  end
end
