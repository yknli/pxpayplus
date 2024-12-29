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

end