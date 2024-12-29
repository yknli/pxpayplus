# frozen_string_literal: true

require_relative "pxpayplus/version"
require_relative "pxpayplus/request"
require_relative "pxpayplus/request_definition"
require_relative "pxpayplus/error"
require "openssl"

module Pxpayplus
  class << self

    # Gets or sets the pxpaypplus secret key
    # @return [String]
    attr_accessor :secret_key

    # Gets or sets the pxpaypplus merchant code
    # @return [String]
    attr_accessor :merchant_code

    # Gets or sets the pxpaypplus api hostname
    # @return [String]
    attr_accessor :api_hostname

    # Configure pxpayplus credentials
    #
    # @example Setup secret key and merchant code
    #   Pxpayplus.configure do |config|
    #     config.secret_key = 'key'
    #     config.merchant_code = 'code'
    #     config.api_hostname = 'example.com'
    #   end
    def configure
      @secret_key = nil
      @merchant_code = nil
      @api_hostname = nil

      raise 'Please use configure method to setup your pxpayplus credentials.' unless block_given?

      yield(self)

      raise 'secret_key not set.' if secret_key.nil?
      raise 'merchant_code not set.' if merchant_code.nil?
      raise 'api_hostname not set.' if api_hostname.nil?
    end

    def sign(data='')
      raise 'data value should be a string.' unless data.is_a?(String)
      raise 'data is empty.' if data.empty?

      digest = OpenSSL::Digest.new('sha256')
      key = [secret_key].pack('H*')
      signature = OpenSSL::HMAC.hexdigest(digest, key, data)
      signature.upcase!
    end

    def verify(data, signature='')
      raise 'signature value should be a string.' unless signature.is_a?(String)
      raise 'signature is empty.' if signature.empty?

      signature.upcase == self.sign(data)
    end
  end
end
