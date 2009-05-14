require 'test_helper'

INVALID_EMAILS = [
  'a', 'not an email', '@', '@example', '@example.com', 'example@',
  'user@example.wrongexample', 'user@@example.com'
]

VALID_EMAILS = [
  'user@example.com', 'user@sub.example.com', 'user.user@example.com',
  'user-user@example.com', 'user_user@example.com', 'user123@example.com',
  'user@example123.com'
]

SHA2_FORMAT =  /\A[a-f0-9]{64}\Z/i

class UserTest < ActiveSupport::TestCase
  # Database
  should_have_index :email, :unique => true
  should_have_index [:id, :token]

  # Mass assignment
  should_allow_mass_assignment_of :email, :name, :password, :password_confirmation
  should_not_allow_mass_assignment_of :id, :last_signin_at, :password_hash,
    :password_salt, :created_at, :modified_at

  # Validations
  should_validate_presence_of :email, :password
  should_allow_values_for :email, *VALID_EMAILS
  should_not_allow_values_for :email, *INVALID_EMAILS
  should_ensure_length_in_range :email, 6..250
  should_ensure_length_in_range :password, 4..32

  context "user" do
    setup { @user = Factory :user }

    should_change 'User.count', :by => 1
    should_validate_uniqueness_of :email

    should "generate random sha2 encoded salt" do
      assert @user.password_salt
      assert_match SHA2_FORMAT, @user.password_salt
    end

    should "hash password" do
      assert @user.password_hash
      assert_match SHA2_FORMAT, @user.password_hash
    end

    should "require password confirmation" do
      @user.password = 'password'
      assert !@user.valid?
      assert @user.errors.on(:password)
    end

    should "not require password on update" do
      @user.password = nil
      @user.password_confirmation = nil
      assert @user.valid?
    end

    context "#authenticate" do    
      should "return user" do
        assert_equal @user, User.authenticate(@user.email, @user.password)
        assert @user.authenticated?(@user.password)
      end

      should "set last_signin_at" do
        time_now = Time.parse("Feb 24 1987")
        Time.stubs(:now).returns(time_now)
        User.authenticate(@user.email, @user.password)
        assert_equal time_now, @user.reload.last_signin_at
      end

      should "return nil with invalid credentials" do
        assert_nil User.authenticate('nonexisting@example.com', 'password')
      end

      should "not authenticate with invalid password" do
        assert_nil User.authenticate(@user.email, 'badpassword')
        assert !@user.authenticated?('badpassword')
      end
    end

    context "#forgotten_password!" do
      should "generate random random base64 encoded token" do
        assert_nil @user.token
        @user.forgot_password!
        assert_match SHA2_FORMAT, @user.token
      end
    end
  end

  context "user with forgotten password" do
    setup do
      @user = Factory :user
      @user.forgot_password!
      @old_password_hash = @user.password_hash
    end

    should "hash new password" do
      assert @user.set_new_password('thenewpass', 'thenewpass')
      assert_not_equal @old_password_hash, @user.password_hash
      assert_nil @user.token
    end

    should "not hash password when not maching passwords given" do
      assert !@user.set_new_password('thenewpass', '')
      assert_equal @old_password_hash, @user.password_hash
      assert @user.token
    end
  end
end
