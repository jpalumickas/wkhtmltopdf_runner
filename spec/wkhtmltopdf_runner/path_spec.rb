# frozen_string_literal: true

RSpec.describe WkhtmltopdfRunner::Path do
  context 'when custom path is provided' do
    let(:path) { '/my/custom/path' }

    it 'returns correct path' do
      expect(described_class.get(path)).to eq(path)
    end
  end

  context 'when path is found from bundler which' do
    it 'returns correct path' do
      allow_any_instance_of(described_class)
        .to receive(:path_from_env).and_return(nil)
      allow(Bundler).to receive(:which)
        .with('wkhtmltopdf').and_return('/custom/wkhtmltopdf')

      expect(described_class.get).to eq('/custom/wkhtmltopdf')
    end
  end

  context 'when path is found from ENV' do
    it 'returns correct path' do
      allow_any_instance_of(described_class)
        .to receive(:path_from_which).and_return(nil)
      allow_any_instance_of(described_class)
        .to receive(:env_paths).and_return(['/custom'])
      allow(File).to receive(:exist?)
        .with('/custom/wkhtmltopdf').and_return(true)

      expect(described_class.get).to eq('/custom/wkhtmltopdf')
    end
  end

  describe '#env_paths' do
    let(:paths) { described_class.new.send(:env_paths) }

    it 'has /usr/bin path' do
      expect(paths).to include('/usr/bin')
    end

    it 'has /usr/local/bin path' do
      expect(paths).to include('/usr/local/bin')
    end

    it 'has home bin path' do
      expect(paths).to include('~/bin')
    end

    it 'has path from ENV' do
      expect(paths).to include(*ENV['PATH'].split(':'))
    end
  end
end
