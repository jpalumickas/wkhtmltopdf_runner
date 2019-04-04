# frozen_string_literal: true

require 'open3'

module WkhtmltopdfRunner
  class Cmd
    attr_reader :url, :file, :options, :config

    def initialize(url:, file:, config:, options: {})
      @url = url
      @file = file
      @config = config
      @options = config.options.merge(options)
    end

    def run
      validate!
      debug_command!

      err, exit_status = Open3.popen3(*command) do |_stdin, _stdout, stderr, wait_thr|
        [stderr.read, wait_thr.value]
      end

      unless exit_status.success?
        raise WkhtmltopdfRunner::Error,
          "Failed to generate PDF. Status: #{exit_status.exitstatus} Error:\n#{err&.strip}"
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
