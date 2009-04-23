# desc "Explaining what the task does"
# task :blueberry_auth do
#   # Task goes here
# end
namespace :blueberry_auth do
  task :sync do
    system "rsync -ruv vendor/plugins/blueberry_auth/db/migrate db"
  end
end