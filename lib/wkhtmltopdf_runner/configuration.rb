# frozen_string_literal: true

require 'logger'

module WkhtmltopdfRunner
  class Configuration
    attr_writer :logger, :options, :debug
    attr_accessor :binary_path

    def logger
      return @logger if defined?(@logger)
      return Rails.logger if defined?(Rails)

      Logger.new(STDOUT)
    end

    def options
      @options || {}
    end

    def debug
      return @debug if defined?(@debug)
      return true if defined?(Rails) && Rails.env.development?

      false
    end
  end
end
