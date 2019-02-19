# frozen_string_literal: true

require 'wkhtmltopdf_runner/configuration'

module WkhtmltopdfRunner
  class Runner
    def pdf_from_file(file, options = {})
      Tempfile.open(['file-', '.pdf']) do |pdf_file|
        run(file.path, pdf_file, options)
        pdf_file.rewind

        return yield(pdf_file) if block_given?

        pdf_file.read
      end
    end

    def pdf_from_string(string, options = {}, &block)
      Tempfile.open(['file-', '.html']) do |html_file|
        html_file.binmode
        html_file.write(string)
        html_file.rewind
        pdf_from_file(html_file, options, &block)
      end
    end

    def run(url, file, options = {})
      WkhtmltopdfRunner::Cmd
        .new(url: url, file: file, config: config, options: options)
        .run
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
