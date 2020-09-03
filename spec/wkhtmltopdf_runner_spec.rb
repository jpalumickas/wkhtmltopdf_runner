# frozen_string_literal: true

RSpec.describe WkhtmltopdfRunner do
  it 'has a version number' do
    expect(WkhtmltopdfRunner::VERSION).not_to be nil
  end

  it 'has a client class' do
    expect(described_class.runner).to be_a(WkhtmltopdfRunner::Runner)
  end

  it 'responds to config' do
    expect(described_class).to respond_to(:config)
  end

  context 'with configuration' do
    let(:logger) { Logger.new($stdout) }

    before do
      described_class.configure do |config|
        config.debug = true
        config.logger = logger
      end
    end

    it 'has correct debug' do
      expect(described_class.config.debug).to be_truthy
    end

    it 'has correct logger' do
      expect(described_class.config.logger).to eq(logger)
    end
  end
end
