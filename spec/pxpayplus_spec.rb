# frozen_string_literal: true

RSpec.describe Pxpayplus do
  it "has a version number" do
    expect(Pxpayplus::VERSION).not_to be nil
  end

  describe 'configure' do
    it "allows configuration through a block" do
      Pxpayplus.configure do |config|
        config.secret_key = 'key'
        config.merchant_code = 'code'
      end

      expect(Pxpayplus.secret_key).to eq('key')
      expect(Pxpayplus.merchant_code).to eq('code')
    end
  end
end
