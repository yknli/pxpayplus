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

    it 'raise an error if no configuration is given' do
      expect { Pxpayplus.configure }.to raise_error(RuntimeError, 'Please use configure method to setup your pxpayplus credentials.')
    end

    it 'raise an error if secret_key not set' do
      expect { Pxpayplus.configure{ |config| } }.to raise_error(RuntimeError, 'secret_key not set.')
    end

    it 'raise an error if merchant_code not set' do
      expect { Pxpayplus.configure{ |config| config.secret_key = 'key' } }.to raise_error(RuntimeError, 'merchant_code not set.')
    end
  end

  context 'when credentials configured' do

    before do
      Pxpayplus.configure do |config|
        config.secret_key = 'test_secret_key'
        config.merchant_code = 'test_merchant_code'
      end
    end

    let(:auth_binding_no) { 'auth_binding_no' }
    let(:req_time) { 'req_time' }
    let(:data) { auth_binding_no + req_time }

    describe 'sign' do
      it 'signs request data correctly' do
        signature = Pxpayplus.sign(data)
        expect(signature).to eq('E458D99A038266FA090CEE7890EE48A2B6FB805F403449859CD7DA62D5415ECB')
      end

      it 'raise an error if data value is not a string' do
        expect { Pxpayplus.sign(123) }.to raise_error(RuntimeError, 'data for signing should be a string.')
      end

      it 'raise an error if data value is empty' do
        expect { Pxpayplus.sign }.to raise_error(RuntimeError, 'data is empty.')
      end
    end

    describe 'verify' do
      it 'verifies request data correctly' do
        signature = Pxpayplus.sign(data)
        expect(Pxpayplus.verify(data, signature)).to eq(true)
      end

      it 'raise an error if signature value is not a string' do
        expect { Pxpayplus.verify(data, 123) }.to raise_error(RuntimeError, 'signature value should be a string.')
      end

      it 'raise an error if signature value is empty' do
        expect { Pxpayplus.verify(data) }.to raise_error(RuntimeError, 'signature is empty.')
      end
    end
  end
end
