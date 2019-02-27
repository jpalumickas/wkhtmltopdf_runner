# frozen_string_literal: true

module WkhtmltopdfRunner
  module Utils
    BLANK_RE = /\A[[:space:]]*\z/.freeze

    def self.dasherize(word)
      underscore(word).tr('_', '-')
    end

    def self.underscore(camel_cased_word)
      return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)

      word = camel_cased_word.to_s.gsub('::', '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word
    end

    def self.blank?(obj)
      return !!BLANK_RE.match(obj) if obj.is_a?(String)

      obj.respond_to?(:empty?) ? !!obj.empty? : !obj
    end

    def self.present?(obj)
      !blank?(obj)
    end

    def self.presence(obj)
      obj if present?(obj)
    end
  end
end
