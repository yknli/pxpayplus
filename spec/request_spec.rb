# frozen_string_literal: true

RSpec.describe Pxpayplus::Request do
  describe 'initialize' do
    subject(:request) { Pxpayplus::Request.new(params: params, method: method, url: url) }

    let(:params) { { key: 'value' } }
    let(:method) { :get }
    let(:url) { 'https://example.com' }

    it 'initializes with given options' do
      expect(request.params).to eq(params)
      expect(request.method).to eq(method)
      expect(request.url).to eq(url)
    end
  end

end