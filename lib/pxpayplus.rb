# frozen_string_literal: true

require_relative "pxpayplus/version"
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

    # Configure pxpayplus credentials
    #
    # @example Setup secret key and merchant code
    #   Pxpayplus.configure do |config|
    #     config.secret_key = 'key'
    #     config.merchant_code = 'code'
    #   end
    def configure
      @secret_key = nil
      @merchant_code = nil

      raise 'Please use configure method to setup your pxpayplus credentials.' unless block_given?

      yield(self)

      raise 'secret_key not set.' if secret_key.nil?
      raise 'merchant_code not set.' if merchant_code.nil?
    end
  end
end
