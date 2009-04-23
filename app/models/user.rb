class User < ActiveRecord::Base
  #
  # Mix-ins
  include UserAuthentication

  #
  # Mass assignment accessible attributes
  attr_accessible :name
end
