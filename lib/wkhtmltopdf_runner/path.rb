# frozen_string_literal: true

module WkhtmltopdfRunner
  class Path
    def self.get(path = nil)
      new(path).call
    end

    EXE_NAME = 'wkhtmltopdf'

    def initialize(path = nil)
      @path = path
    end

    def call
      return @path if WkhtmltopdfRunner::Utils.present?(@path)

      find_wkhtmltopdf_binary_path
    end

    private

    def find_wkhtmltopdf_binary_path
      path_from_which || path_from_env
    end

    def path_from_which
      detected_path = if defined?(Bundler)
        Bundler.which(EXE_NAME)
      else
        `which #{EXE_NAME}`.chomp
      end

      WkhtmltopdfRunner::Utils.presence(detected_path)
    rescue StandardError
      nil
    end

    def path_from_env
      env_paths
        .map { |l| File.expand_path(File.join(l, EXE_NAME)) }
        .detect { |location| File.exist?(location) }
    end

    def env_paths
      possible_locations = [
        ENV['PATH'].split(File::PATH_SEPARATOR),
        %w[/usr/bin /usr/local/bin]
      ]

      possible_locations << %w[~/bin] if ENV.key?('HOME')
      possible_locations.flatten.uniq
    end
  end
end
