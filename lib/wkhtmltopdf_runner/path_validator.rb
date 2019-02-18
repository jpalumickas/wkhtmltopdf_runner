# frozen_string_literal: true

module WkhtmltopdfRunner
  class PathValidator
    def self.validate!(path)
      new(path).validate!
    end

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def validate!
      validate_if_path_exists!
      validate_if_path_executable!

      true
    end

    private

    def validate_if_path_exists!
      return if path && !path.empty? && File.exist?(path)

      raise WkhtmltopdfRunner::InvalidPathError,
        "Cannot find wkhtmltopdf location #{path}".strip
    end

    def validate_if_path_executable!
      return if File.executable?(path)

      raise WkhtmltopdfRunner::InvalidPathError,
        "#{path} is not executable."
    end
  end
end
