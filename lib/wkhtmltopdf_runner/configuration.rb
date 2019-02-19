# frozen_string_literal: true

require 'logger'

module WkhtmltopdfRunner
  class Configuration
    attr_writer :logger, :options
    attr_accessor :debug, :binary_path

    def logger
      @logger ||= begin
        return Rails.logger if defined?(Rails)

        Logger.new(STDOUT)
      end
    end

    def options
      @options || {}
    end
  end
end
