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
    let(:method) { :post }
    let(:url) { 'https://example.com' }

    it 'initializes with given options' do
      expect(request.params).to eq(params)
      expect(request.method).to eq(method)
      expect(request.url).to eq(url)
    end
  end

  context 'when request initialized' do
    let(:params) { { auth_binding_no: 'auth_binding_no', req_time: 'req_time' } }
    let(:method) { :post }
    let(:url) { 'https://example.com' }

    let(:request) { Pxpayplus::Request.new(params: params, method: method, url: url) }

    describe 'signature_fields' do
      it 'returns waht fields to sign in params' do
        expect(request.signature_fields).to eq([:auth_binding_no, :req_time])
      end
    end

    describe 'signature_params' do
      it 'returns a hash of signature fields and values' do
        expect(request.signature_params).to eq(params)
      end
    end

    describe 'signature' do
      subject(:signature) { request.signature }
      it 'signs signature by params' do
        expect(signature).to eq ('E458D99A038266FA090CEE7890EE48A2B6FB805F403449859CD7DA62D5415ECB')
      end
    end

    describe 'headers' do
      let(:signature) { request.signature }
      it 'returns headers to send in api request' do
        expect(request.headers).to eq ({
          'Content-Type': 'application/json;charset=utf-8',
          'PX-MerCode': 'test_merchant_code',
          'PX-SignValue': signature,
        })
      end
    end

    describe 'send_request' do
      it 'sends the request and gets successful response' do
        stub_request(:post, url).to_return(body: '{"status_code": "0000"}', status: 200)
        expect(request.send_request).to eq({ "status_code" => '0000'})
      end

      it 'raises error when gets status-200 error response' do
        stub_request(:post, url).to_return(body: '{"status_code": "AD6000", "status_message": "Invalid Params."}', status: 200)
        expect { request.send_request }.to raise_error(Pxpayplus::Error, 'Invalid Params.')
      end

      it 'raises error when gets non-status-200 error responses' do
        stub_request(:post, url).to_return(body: 'Internal Server Error.', status: 500)
        expect { request.send_request }.to raise_error(Pxpayplus::Error, 'Internal Server Error.')
      end

      it 'raises error when gets runtime errors' do
        allow_any_instance_of(Pxpayplus::Request).to receive(:send_request).and_raise('Unknown Error.')
        expect { request.send_request }.to raise_error('Unknown Error.')
      end

      it 'raises error when gets timeout error' do
        stub_request(:post, url).to_timeout
        expect { request.send_request }.to raise_error('Request Timed Out.')
      end
    end
  end
end