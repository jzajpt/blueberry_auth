Factory.define :user do |user|
  user.sequence(:name) { |n| "User #{n}" }
  user.sequence(:email) { |n| "name#{n}@example.com" }
  user.password { 'password123' }
  user.password_confirmation { 'password123' }
end

