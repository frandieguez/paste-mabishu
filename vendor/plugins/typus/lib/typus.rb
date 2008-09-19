module Typus

  class << self

    def applications
      apps = []
      Typus::Configuration.config.to_a.each do |model|
        if model[1].has_key? 'application'
          apps << model[1]['application']
        end
      end
      return apps.uniq.sort
    end

    def modules(app_name)
      submodules = []
      Typus::Configuration.config.to_a.each do |model|
        if model[1]['application'] == app_name
          submodules << model[0]
        end
      end
      return submodules.sort
    end

    def submodules(module_name)
      submodules = []
      Typus::Configuration.config.to_a.each do |model|
        if model[1]['module'] == module_name
          submodules << model[0]
        end
      end
      return submodules.sort
    end

    def parent_module(submodule_name)
      Typus::Configuration.config[submodule_name]['module']
    end

    def parent_application(module_name)
      Typus::Configuration.config[module_name]['application']
    end

    def enable
      enable_configuration
      enable_orm
      enable_routes
      enable_string
      enable_authentication
      enable_patches if Rails.vendor_rails?
      enable_object
    end

    def enable_configuration
      require 'typus/configuration'
    end

    def enable_orm
      require 'typus/active_record'
    end

    def enable_routes
      require 'typus/routes'
    end

    def enable_string
      require 'typus/string'
    end

    def enable_authentication
      require 'typus/authentication'
    end

    def enable_patches
      require 'typus/patches'
    end

    def enable_object
      require 'typus/object'
    end

  end

end