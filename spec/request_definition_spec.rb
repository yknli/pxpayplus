# frozen_string_literal: true

RSpec.describe Pxpayplus::RequestDefinition do

  before(:all) do
    Pxpayplus.configure do |config|
      config.secret_key = 'test_secret_key'
      config.merchant_code = 'test_merchant_code'
      config.api_hostname = 'example.com'
    end
  end

  describe 'CreateAuthOrderRequest' do
    subject(:request) { Pxpayplus::RequestDefinition::CreateAuthOrderRequest.new }

    describe 'signature_params' do
      it 'returns overrided signature_fields' do
        expect(request.signature_fields).to eq([:mer_order_no, :amount, :device_type, :req_time])
      end
    end

    describe 'method' do
      it 'returns overrided method' do
        expect(request.method).to eq(:post)
      end
    end

    describe 'url' do
      it 'returns overrided url' do
        expect(request.url).to eq("https://#{Pxpayplus.api_hostname}/CreateAuthOrder")
      end
    end
  end

  describe 'DebitRequest' do
    subject(:request) { Pxpayplus::RequestDefinition::DebitRequest.new }

    describe 'signature_params' do
      it 'returns overrided signature_fields' do
        expect(request.signature_fields).to eq([:mer_trade_no, :auth_binding_no, :mer_order_no, :amount, :req_time])
      end
    end

    describe 'method' do
      it 'returns overrided method' do
        expect(request.method).to eq(:post)
      end
    end

    describe 'url' do
      it 'returns overrided url' do
        expect(request.url).to eq("https://#{Pxpayplus.api_hostname}/Debit")
      end
    end
  end

  describe 'UnbindRequest' do
    subject(:request) { Pxpayplus::RequestDefinition::UnbindRequest.new }

    describe 'signature_params' do
      it 'returns overrided signature_fields' do
        expect(request.signature_fields).to eq([:mer_order_no, :auth_binding_no, :mer_member_token, :req_time])
      end
    end

    describe 'method' do
      it 'returns overrided method' do
        expect(request.method).to eq(:post)
      end
    end

    describe 'url' do
      it 'returns overrided url' do
        expect(request.url).to eq("https://#{Pxpayplus.api_hostname}/Unbind")
      end
    end
  end

  describe 'RefundRequest' do
    subject(:request) { Pxpayplus::RequestDefinition::RefundRequest.new }

    describe 'signature_params' do
      it 'returns overrided signature_fields' do
        expect(request.signature_fields).to eq([:mer_trade_no, :px_trade_no, :refund_mer_trade_no, :amount, :req_time])
      end
    end

    describe 'method' do
      it 'returns overrided method' do
        expect(request.method).to eq(:post)
      end
    end

    describe 'url' do
      it 'returns overrided url' do
        expect(request.url).to eq("https://#{Pxpayplus.api_hostname}/Refund")
      end
    end
  end

  describe 'CheckOrderStatusRequest' do
    subject(:request) { Pxpayplus::RequestDefinition::CheckOrderStatusRequest.new(params: params) }

    let(:params) { { mer_trade_no: 'mer_trade_no', req_time: 'req_time' } }

    describe 'signature_params' do
      it 'returns overrided signature_fields' do
        expect(request.signature_fields).to eq([:mer_trade_no, :req_time])
      end
    end

    describe 'method' do
      it 'returns overrided method' do
        expect(request.method).to eq(:get)
      end
    end

    describe 'url' do
      it 'returns overrided url' do
        expect(request.url).to eq("https://#{Pxpayplus.api_hostname}/CheckOrderStatus/#{params[:mer_trade_no]}/#{params[:req_time]}")
      end
    end
  end

end
