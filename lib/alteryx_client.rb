require_relative "alteryx_client/version"
require_relative "alteryx_client/configuration"
require_relative "alteryx_client/user"
require_relative "alteryx_client/client"
require_relative "alteryx_client/error"

require "rest-client"
require "awesome_print"
require "logger"

module AlteryxClient
  class << self
    attr_writer :configuration
  end

  def self.configuration(initialization_opts = {})
    @configuration ||= Configuration.new(initialization_opts)
  end

  def self.configure(initialization_opts = {})
    config = configuration(initialization_opts)
    yield(config) if block_given?
  end
end
