# frozen_string_literal: true

RSpec.describe Pxpayplus::Request do

  before(:all) do
    Pxpayplus.configure do |config|
      config.secret_key = 'test_secret_key'
      config.merchant_code = 'test_merchant_code'
    end
  end

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

  context 'when request initialized' do
    let(:params) { { auth_binding_no: 'auth_binding_no', req_time: 'req_time' } }
    let(:method) { :get }
    let(:url) { 'https://example.com' }

    let(:request) { Pxpayplus::Request.new(params: params, method: method, url: url) }

    describe 'signature' do
      subject(:signature) { request.signature }
      it 'signs signature by params' do
        expect(signature).to eq ('E458D99A038266FA090CEE7890EE48A2B6FB805F403449859CD7DA62D5415ECB')
      end
    end
  end
end