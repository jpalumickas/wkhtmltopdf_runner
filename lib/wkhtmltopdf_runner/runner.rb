# frozen_string_literal: true

require 'wkhtmltopdf_runner/configuration'

module WkhtmltopdfRunner
  class Runner
    def pdf_from_string(string, options = {})
      Tempfile.open(['file-', '.pdf']) do |pdf_file|
        Tempfile.open(['file-', '.html']) do |html_file|
          html_file.binmode
          html_file.write(string)
          html_file.rewind

          run(html_file.path, pdf_file, options)
          pdf_file.rewind

          return yield(pdf_file) if block_given?

          pdf_file.read
        end
      end
    end

    def run(url, file, options = {})
      WkhtmltopdfRunner::Cmd.new(url, file, config, options).run
    end

    def config
      @config ||= Configuration.new
    end
    alias configuration config

    # Configure client with a block of settings.
    def configure
      yield(config) if block_given?
      true
    end
  end
end
