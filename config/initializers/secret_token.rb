Rails.application.config.secret_key_base = \
  ENV.fetch('RAILS_SECRET_KEY_BASE') { ENV.fetch('SECRET_KEY_BASE') }
