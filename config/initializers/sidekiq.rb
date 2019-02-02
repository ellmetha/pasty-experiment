# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

sidekiq_config = { url: ENV.fetch('REDIS_URL') }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

sidekiq_username = ENV.fetch('SIDEKIQ_WEB_USERNAME')
sidekiq_password = ENV.fetch('SIDEKIQ_WEB_PASSWORD')
Sidekiq::Web.app_url = '/'
Sidekiq::Web.use(Rack::Auth::Basic, 'Application') do |username, password|
  username == sidekiq_username &&
    ActiveSupport::SecurityUtils.secure_compare(password, sidekiq_password)
end
