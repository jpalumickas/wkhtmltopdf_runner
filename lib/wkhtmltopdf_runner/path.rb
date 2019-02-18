# frozen_string_literal: true

module WkhtmltopdfRunner
  class Path
    EXE_NAME = 'wkhtmltopdf'

    def initialize(path = nil)
      @path = path
    end

    def call
      @path || find_wkhtmltopdf_binary_path
    end

    private

    def find_wkhtmltopdf_binary_path
      path_from_which || path_from_env
    end

    def path_from_which
      detected_path = if defined?(Bundler)
        Bundler.which(EXE_NAME).chomp
      else
        `which #{EXE_NAME}`.chomp
      end

      Wkhtmltopdf::Utils.present?(detected_path) && detected_path
    rescue StandardError
      nil
    end

    def path_from_env
      possible_locations = [
        ENV['PATH'].split(':'),
        %w[/usr/bin /usr/local/bin]
      ]

      possible_locations << %w[~/bin] if ENV.key?('HOME')
      possible_locations
        .flat_map { |l| File.expand_path("#{l}/#{EXE_NAME}") }
        .detect { |location| File.exist?(location) }
    end
  end
end
