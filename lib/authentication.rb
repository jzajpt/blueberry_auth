module Authentication
  def self.included(controller)
    controller.class_eval do
      helper_method :current_user
      helper_method :signed_in?
    end
  end

  protected

  def redirect_back_or_to(default)
    session[:return_to] ||= params[:return_to]
    if session[:return_to]
      redirect_to(session[:return_to])
    else
      redirect_to(default)
    end
    session[:return_to] = nil
  end

  def redirect_to_with_success_flash(path)
    controller = params[:controller].gsub('/', '.')
    action = params[:action]
    flash[:notice] = I18n.t("#{controller}.#{action}.success")
    redirect_to path
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in_user(user)
    session[:user_id] = user.id if user
  end

  def sign_out_user
    session[:user_id] = nil
  end

  def current_user
    @_current_user ||= user_from_session
  end

  def user_from_session
    user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def authenticate
    deny_access unless signed_in?
  end

  def store_location
    session[:return_to] = request.request_uri if request.get?
  end

  def deny_access(flash_message = nil, opts = {})
    store_location
    flash[:failure] = flash_message if flash_message
    redirect_to new_session_url
  end
end