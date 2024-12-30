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
    context 'with unknown action' do
      it 'raises NoMethodError' do
        expect { client.unknown_action }.to raise_error(NoMethodError)
      end
    end

    context 'with known action' do
      let(:action) { :create_auth_order }

      context 'when configuration not setup properly' do
        let(:params) { { mer_order_no: 'test_mer_order_no', amount: 0, device_type: 1, req_time: 'test_req_time' } }

        it 'raises configuration setup error' do
          expect { client.send(action, params) }.to raise_error(RuntimeError, 'secret_key not set.')
        end
      end

      context 'when configuration setup properly' do
        before(:all) do
          Pxpayplus.configure do |config|
            config.secret_key = 'test_secret_key'
            config.merchant_code = 'test_merchant_code'
            config.api_hostname = 'example.com'
          end
        end

        describe 'create_auth_order' do
          let(:params) { { mer_order_no: 'test_mer_order_no', amount: 0, device_type: 1, req_time: 'test_req_time' } }
          let(:request) { Pxpayplus::RequestDefinition::CreateAuthOrderRequest.new }

          it 'sends create_auth_order request correctly' do
            parsed_params = params.map { |k, v| [ k.to_s, v ] }.to_h
            stub_request(request.method, request.url).
              with(body: parsed_params).
              to_return(body: '{"status_code": "0000"}', status: 200)

            expect(client.create_auth_order(params)).to eq({ "status_code" => '0000'})
          end
        end

        describe 'debit' do
          let(:params) { { mer_trade_no: 'test_mer_trade_no', auth_binding_no: 'test_auth_binding_no', mer_order_no: 'test_mer_order_no', amount: 0, req_time: 'test_req_time' } }
          let(:request) { Pxpayplus::RequestDefinition::DebitRequest.new }

          it 'sends debit request correctly' do
            parsed_params = params.map { |k, v| [ k.to_s, v ] }.to_h
            stub_request(request.method, request.url).
              with(body: parsed_params).
              to_return(body: '{"status_code": "0000"}', status: 200)

            expect(client.debit(params)).to eq({ "status_code" => '0000'})
          end
        end

        describe 'unbind' do
          let(:params) { { mer_order_no: 'test_mer_order_no', auth_binding_no: 'test_auth_binding_no', mer_member_token: 'test_mer_member_token', req_time: 'test_req_time' } }
          let(:request) { Pxpayplus::RequestDefinition::UnbindRequest.new }

          it 'sends unbind request correctly' do
            parsed_params = params.map { |k, v| [ k.to_s, v ] }.to_h
            stub_request(request.method, request.url).
              with(body: parsed_params).
              to_return(body: '{"status_code": "0000"}', status: 200)

            expect(client.unbind(params)).to eq({ "status_code" => '0000'})
          end
        end

        describe 'refund' do
          let(:params) { { mer_trade_no: 'test_mer_trade_no', px_trade_no: 'test_px_trade_no', refund_mer_trade_no: 'test_refund_mer_trade_no', amount: 0, req_time: 'test_req_time' } }
          let(:request) { Pxpayplus::RequestDefinition::RefundRequest.new }

          it 'sends refund request correctly' do
            parsed_params = params.map { |k, v| [ k.to_s, v ] }.to_h
            stub_request(request.method, request.url).
              with(body: parsed_params).
              to_return(body: '{"status_code": "0000"}', status: 200)

            expect(client.refund(params)).to eq({ "status_code" => '0000'})
          end
        end

        describe 'check_order_status' do
          let(:params) { { mer_trade_no: 'test_mer_trade_no', req_time: 'test_req_time' } }
          let(:request) { Pxpayplus::RequestDefinition::CheckOrderStatusRequest.new(params: params) }

          it 'sends check_order_status request correctly' do
            stub_request(request.method, request.url).
              to_return(body: '{"status_code": "0000"}', status: 200)

            expect(client.check_order_status(params)).to eq({ "status_code" => '0000'})
          end
        end

        describe 'update_debit_time' do
          let(:params) { { mer_trade_no: 'test_mer_trade_no', px_trade_no: 'test_px_trade_no', req_time: 'test_req_time' } }
          let(:request) { Pxpayplus::RequestDefinition::UpdateDebitTimeRequest.new }

          it 'sends update_debit_time request correctly' do
            parsed_params = params.map { |k, v| [ k.to_s, v ] }.to_h
            stub_request(request.method, request.url).
              with(body: parsed_params).
              to_return(body: '{"status_code": "0000"}', status: 200)

            expect(client.update_debit_time(params)).to eq({ "status_code" => '0000'})
          end
        end

      end
    end
  end

end
