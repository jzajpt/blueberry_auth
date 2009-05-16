
# Hack to load engine's routes after application routes, thank you Thoughtbot.
class ActionController::Routing::RouteSet
  def load_routes_with_evergreen!
    evergreen_routes = File.expand_path(File.dirname(__FILE__) + '/../config/evergreen_routes.rb')
    unless configuration_files.include? evergreen_routes
      add_configuration_file(evergreen_routes)
    end
    load_routes_without_evergreen!
  end

  alias_method_chain :load_routes!, :evergreen
end
