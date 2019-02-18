# frozen_string_literal: true

require 'open3'

module WkhtmltopdfRunner
  class Cmd
    attr_reader :url, :file, :options

    def initialize(url, file, options = {})
      @url = url
      @file = file
      @options = options
    end

    def call
      err = Open3.popen3(*command) do |_stdin, _stdout, stderr|
        stderr.read
      end

      unless err.empty?
        raise WkhtmltopdfRunner::Path,
          "Error generating PDF. Command Error:\n#{err}"
      end

      true
    end

    private

    def command
      command = [wkhtmltopdf_path]
      command += formatted_options
      command << url
      command << file_path
    end

    def formatted_options
      options.each_with_object([]) do |(key, value), list|
        next if value == false

        if value == true
          list << "--#{Utils.dasherize(key)}"
        else
          list << "--#{Utils.dasherize(key)} #{Array(value).join(' ')}"
        end
      end
    end

    def file_path
      if file.respond_to?(:path)
        file.path.to_s
      else
        file.to_s
      end
    end

    def wkhtmltopdf_path
      @wkhtmltopdf_path ||= WkhtmltopdfRunner::Path.new.call
    end
  end
end