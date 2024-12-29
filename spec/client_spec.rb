# frozen_string_literal: true

RSpec.describe Pxpayplus::Client do

  let(:client) { Pxpayplus::Client.new }

  describe 'actions' do
    it 'returns all available api actions' do
      expect(client.actions).to eq([:create_auth_order, :debit, :unbind, :refund, :check_order_status, :update_debit_time])
    end
  end

  describe 'action_to_request_klass_name' do
    it 'returns request class name for given action' do
      klass_name = client.send(:action_to_request_klass_name, :create_auth_order)
      expect(klass_name).to eq('Pxpayplus::RequestDefinition::CreateAuthOrderRequest')

      klass_name = client.send(:action_to_request_klass_name, :debit)
      expect(klass_name).to eq('Pxpayplus::RequestDefinition::DebitRequest')

      klass_name = client.send(:action_to_request_klass_name, :unbind)
      expect(klass_name).to eq('Pxpayplus::RequestDefinition::UnbindRequest')

      klass_name = client.send(:action_to_request_klass_name, :refund)
      expect(klass_name).to eq('Pxpayplus::RequestDefinition::RefundRequest')

      klass_name = client.send(:action_to_request_klass_name, :check_order_status)
      expect(klass_name).to eq('Pxpayplus::RequestDefinition::CheckOrderStatusRequest')

      klass_name = client.send(:action_to_request_klass_name, :update_debit_time)
      expect(klass_name).to eq('Pxpayplus::RequestDefinition::UpdateDebitTimeRequest')
    end
  end

  describe 'constantize' do
    it 'returns request class by given request class name' do
      klass = client.send(:constantize_request_klass, 'Pxpayplus::RequestDefinition::CreateAuthOrderRequest')
      expect(klass).to eq(Pxpayplus::RequestDefinition::CreateAuthOrderRequest)

      klass = client.send(:constantize_request_klass, 'Pxpayplus::RequestDefinition::DebitRequest')
      expect(klass).to eq(Pxpayplus::RequestDefinition::DebitRequest)

      klass = client.send(:constantize_request_klass, 'Pxpayplus::RequestDefinition::UnbindRequest')
      expect(klass).to eq(Pxpayplus::RequestDefinition::UnbindRequest)

      klass = client.send(:constantize_request_klass, 'Pxpayplus::RequestDefinition::RefundRequest')
      expect(klass).to eq(Pxpayplus::RequestDefinition::RefundRequest)

      klass = client.send(:constantize_request_klass, 'Pxpayplus::RequestDefinition::CheckOrderStatusRequest')
      expect(klass).to eq(Pxpayplus::RequestDefinition::CheckOrderStatusRequest)

      klass = client.send(:constantize_request_klass, 'Pxpayplus::RequestDefinition::UpdateDebitTimeRequest')
      expect(klass).to eq(Pxpayplus::RequestDefinition::UpdateDebitTimeRequest)
    end
  end

  describe 'method_missing' do
    let(:params) { { mer_order_no: 'test_mer_order_no', amount: 0, device_type: 1, req_time: 'test_req_time' } }

    context 'with initialized request' do

      let(:request) { Pxpayplus::RequestDefinition::CreateAuthOrderRequest.new }

      it 'raises error when configuration not setup properly' do
        expect { client.create_auth_order(params) }.to raise_error(RuntimeError, 'secret_key not set.')
      end

      context 'with configuration setup properly' do

        before(:all) do
          Pxpayplus.configure do |config|
            config.secret_key = 'test_secret_key'
            config.merchant_code = 'test_merchant_code'
            config.api_hostname = 'example.com'
          end
        end

        it 'sends request successfully' do
          parsed_params = params.map { |k, v| [ k.to_s, v ] }.to_h
          stub_request(request.method, request.url).
            with(body: parsed_params).
            to_return(body: '{"status_code": "0000"}', status: 200)

          expect(client.create_auth_order(params)).to eq({ "status_code" => '0000'})
        end
      end
    end
  end

end
