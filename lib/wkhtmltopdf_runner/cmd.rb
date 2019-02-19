# frozen_string_literal: true

require 'open3'

module WkhtmltopdfRunner
  class Cmd
    attr_reader :url, :file, :options, :config

    def initialize(url, file, config, options = {})
      @url = url
      @file = file
      @config = config
      @options = options.reverse_merge(config.options)
    end

    def run
      validate!
      debug_command!

      err = Open3.popen3(*command) do |_stdin, _stdout, stderr|
        stderr.read
      end

      unless err&.strip&.empty?
        raise WkhtmltopdfRunner::Error,
          "Error generating PDF. Command Error:\n#{err}"
      end

      true
    end

    private

    def validate!
      WkhtmltopdfRunner::PathValidator.validate!(wkhtmltopdf_path)
    end

    def debug_command!
      return unless config.debug

      config.logger.debug("[WkhtmltopdfRunner] Running #{command.join(' ')}")
    end

    def command
      command = [wkhtmltopdf_path]
      command << '-q' # Output is in stderr so we need to run in quiet mode
      command += formatted_options
      command << url
      command << file_path
    end

    def formatted_options
      opts = options.each_with_object([]) do |(key, value), list|
        next if value == false

        dashed_key = WkhtmltopdfRunner::Utils.dasherize(key.to_s)

        list << if value == true
          "--#{dashed_key}"
        else
          ["--#{dashed_key}"].concat(Array(value))
        end
      end

      opts.flatten
    end

    def file_path
      if file.respond_to?(:path)
        file.path.to_s
      else
        file.to_s
      end
    end

    def wkhtmltopdf_path
      @wkhtmltopdf_path ||= WkhtmltopdfRunner::Path.new(config.binary_path).call
    end
  end
end
