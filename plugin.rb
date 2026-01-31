# frozen_string_literal: true

# name: discourse-plugin-name
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :aliexpress_redirect_enabled

module ::MyPluginModule
  PLUGIN_NAME = "discourse-plugin-name"
end

after_initialize do
  require_relative "lib/aliexpress_redirect/middleware"

  Discourse::Application.config.middleware.use AliExpressRedirect::Middleware
end