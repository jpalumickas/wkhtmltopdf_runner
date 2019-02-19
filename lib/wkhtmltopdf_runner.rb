# frozen_string_literal: true

require 'wkhtmltopdf_runner/version'
require 'wkhtmltopdf_runner/error'
require 'wkhtmltopdf_runner/utils'
require 'wkhtmltopdf_runner/path_validator'
require 'wkhtmltopdf_runner/path'
require 'wkhtmltopdf_runner/cmd'
require 'wkhtmltopdf_runner/runner'

module WkhtmltopdfRunner
  class << self
    def runner
      @runner ||= WkhtmltopdfRunner::Runner.new
    end

    private

    def method_missing(method_name, *args, &block)
      return super unless runner.respond_to?(method_name)

      runner.send(method_name, *args, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      runner.respond_to?(method_name, include_private)
    end
  end
end
