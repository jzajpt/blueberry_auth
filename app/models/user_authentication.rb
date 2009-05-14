module UserAuthentication
  require 'digest/sha1'

  # Constants
  LOCALPART_REGEXP = /[-a-z0-9\._]+/
  DOMAIN_REGEXP = /[-a-z0-9\.]+\.[a-z]{2,6}/
  EMAIL_REGEXP = /\A#{LOCALPART_REGEXP}\@#{DOMAIN_REGEXP}\Z/

  class << self
    def included(model)
      model.extend ClassMethods
      model.send :include, InstanceMethods

      model.class_eval do
        # Virtual attributes
        attr_accessor :password, :password_confirmation

        # Mass assignment accessible attributes
        attr_accessible :name, :email, :password, :password_confirmation

        # Validations
        validates_presence_of   :email
        validates_uniqueness_of :email
        validates_format_of     :email, :with => EMAIL_REGEXP
        validates_length_of     :email, :in => 6..250

        with_options :if => :password_required? do |o|
          o.validates_presence_of     :password
          o.validates_confirmation_of :password
          o.validates_length_of       :password, :in => 4..32
        end

        # Callbacks
        before_save :hash_password
      end
    end
  end

  # Model class methods
  module ClassMethods
    def authenticate(email, password)
      user = find_by_email(email)
      if user && user.authenticated?(password)
        user.update_attribute :last_signin_at, Time.now
        user
      end
    end

    def generate_random_hash
      generate_hash(Time.now, rand)
    end

    def generate_hash(*string)
      Digest::SHA2.hexdigest(string.flatten.join('---'))
    end
  end

  # Model instance methods
  module InstanceMethods
    def forgot_password!
      generate_token
      save(false)
    end

    def set_new_password(new_password, new_password_confirmation)
      self.password = new_password
      self.password_confirmation = new_password_confirmation
      self.token = nil if valid?
      save
    end

    def authenticated?(password)
      password_hash == encrypt_password(password)
    end

    protected

    def password_required?
      password_hash.blank? || !password.blank?
    end

    def hash_password
      return if password.blank?
      self.password_salt = self.class.generate_random_hash if new_record?
      self.password_hash = encrypt_password(password)
    end

    def encrypt_password(password)
      hash = self.class.generate_hash(password, password_salt, AUTH_SITE_KEY)
      PASSWORD_HASH_ITERATIONS.times do
        hash = self.class.generate_hash(hash)
      end
      hash
    end

    def generate_token
      self.token = self.class.generate_random_hash
    end
  end
end