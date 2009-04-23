# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Form helpers

  def labeled_form_for(*args, &block)
    options = args.extract_options!.merge(:builder => LabeledFormBuilder)
    form_for(*(args + [options]), &block)
  end

  def multipart_form_for(*args, &block)
    options = args.extract_options!.merge(:html => { :multipart => true })
    form_for(*(args + [options]), &block)
  end

  # Translation helpers

  def t_or_false(key)
    I18n.t(key, :raise => true)
  rescue I18n::MissingTranslationData
    false
  end

  def current_t_prefix
    controller = params[:controller].gsub('/', '.')
    action = params[:action]
    "#{controller}.#{action}"
  end

  # Layout helpers

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def i18n_title
    controller = params[:controller].gsub('/', '.')
    action = params[:action]
    if !(t = t_or_false("#{controller}.#{action}.title"))
      # try new or edit action instead of create or update
      action = 'new' if action == 'create'
      action = 'edit' if action == 'update'
      t = t_or_false("#{controller}.#{action}.title")
      t = nil if !t
    end
    t
  end

  def javascript_auth_token
    javascript_tag "var AUTH_TOKEN = #{form_authenticity_token.inspect};" if protect_against_forgery?
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end

  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end

  def body_class(class_name)
    content_for(:body_class, class_name)
  end

  # Link helpers

  def link_to_show(path, text = nil)
    text ||= t('common.show')
    link_to text, path
  end

  def link_to_edit(path, text = nil)
    text ||= t('common.edit')
    link_to text, path
  end

  def link_to_delete(path, text = nil)
    text ||= t('common.delete')
    confirm = t('common.confirm_delete')
    link_to text, path, :confirm => confirm, :class => 'delete'
  end

end