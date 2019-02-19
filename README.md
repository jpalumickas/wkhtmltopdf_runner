# Wkhtmltopdf Runner

This gem is a wrapper for a popular `wkhtmltopdf` library to generate PDF files from HTML.

## Installation

Add this line to your application's Gemfile and then run `bundle install`:

```ruby
gem 'wkhtmltopdf_runner'
```

You also need to have installed `wkhtmltopdf`. Easy way to do that is to add binary files to your Gemfile.
```ruby
gem 'wkhtmltopdf-binary' # or 'wkhtmltopdf-binary-edge'
```

If you have custom path for `wkhtmltopdf` please see [Configuration](#configuration)

## Usage

### Write to File

Use block which has File argument that will be returned after PDF generation.

You can render PDF from HTML string:

```rb
string = '<h1>Hello user</h1>'

WkhtmltopdfRunner.pdf_from_string(string) do |file|
  user.document.attach(io: file, file_name: 'document.pdf')
end
```

You can render PDF from HTML file:

```rb
  File.open('index.html') do |html_file|
    WkhtmltopdfRunner.pdf_from_file(html_file) do |file|
      user.document.attach(io: file, file_name: 'document.pdf')
    end
  end
```

You can render PDF from URL:

```rb
  WkhtmltopdfRunner.pdf_from_url('https://github.com') do |file|
    user.document.attach(io: file, file_name: 'document.pdf')
  end
```

### Render to String

If you will not provide block, PDF string will be returned.

> **Note:* Be careful when using this method because all PDF content will
> be stored in Memory. Better to use block which will return file. See examples
> above.

```rb
pdf_string = WkhtmltopdfRunner.pdf_from_url('https://github.com')
```

## Configuration

If you're using Rails, create file in `config/initializers/wkhtmltopdf_runner.rb'

```rb
WkhtmltopdfRunner.configure do |config|
  config.debug = true # Default: false
  config.logger = Logger.new('runner.log') # Default: STDOUT or Rails.logger in Rails
  config.binary_path = '/path/to/wkhtmltopdf' # Default: will search automatically in PATH or Gemfile
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jpalumickas/wkhtmltopdf_runner. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the WkhtmltopdfRunner project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jpalumickas/wkhtmltopdf_runner/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
