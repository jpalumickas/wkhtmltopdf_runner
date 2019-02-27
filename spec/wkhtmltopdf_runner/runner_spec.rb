# frozen_string_literal: true

RSpec.describe WkhtmltopdfRunner::Runner do
  let(:runner) do
    runner = described_class.new
    runner.config.debug = true
    runner
  end

  it 'generates pdf from string' do
    result = runner.pdf_from_string(
      'test',
      page_size: 'A4',
      disable_smart_shrinking: true
    )

    expect(result).to match(/%%EOF/)
  end
end
