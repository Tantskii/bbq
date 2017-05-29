Rails.application.configure do

  config.cache_classes = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.log_level = :debug

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  config.active_record.dump_schema_after_migration = false
  
  config.action_mailer.default_url_options   = {host: 'bbqmeeting.herokuapp.com'}

  # Вываливать ли посетителю сайта ошибки при отправке писем
  config.action_mailer.raise_delivery_errors = false

  # Делать рассылку писем (если false — мэйлер только имитирует работу, реальных писем не уходит)
  config.action_mailer.perform_deliveries = true

  # отправка почты по протоколу SMTP
  config.action_mailer.delivery_method = :smtp

  # Настройки для Sendgrid
  ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => 'heroku.com',
      :enable_starttls_auto => true
  }
end