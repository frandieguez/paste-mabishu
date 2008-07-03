#ENV['RAILS_ENV'] ||= 'production'
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_resource, :action_mailer ]
  config.gem "ultraviolet"
  #config.gem "mislav-will_paginate"
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.log_level = :debug
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_pastie-mabishu_session',
    :secret      => '10b8fb46fd275f6e4e7e822ba2c34db4981c792c112c0fb1dc18b4c6a2ab3e2d94e7776d52e5ebcc9c431467366f702082629111a154bc7a735b191f40bd6674'
  }
  # config.action_controller.session_store = :active_record_store
  # config.active_record.schema_format = :sql
  # config.active_record.observers = :cacher, :garbage_collector

  require "coderay"
  #require 'will_paginate'

end
