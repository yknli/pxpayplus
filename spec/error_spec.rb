# frozen_string_literal: true

RSpec.describe Pxpayplus::Error do

  describe 'initialize' do
    subject(:error) { Pxpayplus::Error.new(message) }

    let(:message) { 'Error Message.' }
    it 'initializes with given error message' do
      expect(error.message).to eq('Error Message.')
    end
  end

end
