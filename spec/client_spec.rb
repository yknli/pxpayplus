# frozen_string_literal: true

RSpec.describe Pxpayplus::Client do

  let(:client) { Pxpayplus::Client.new }

  describe 'actions' do
    it 'returns all available api actions' do
      expect(client.actions).to eq([:create_auth_order, :debit, :unbind, :refund, :check_order_status, :update_debit_time])
    end
  end

end