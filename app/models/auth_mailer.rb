class AuthMailer < ActionMailer::Base
  default_url_options[:host] = HOST

  def password_change(user)
    from       AUTH_MAILER_FROM
    recipients user.email
    subject    I18n.t('auth_mailer.password_change.subject')
    body       :user => user
  end
end
