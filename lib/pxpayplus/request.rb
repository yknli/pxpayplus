require 'rest-client'
require 'json'

module Pxpayplus
  class Request

    attr_accessor :params, :method, :url

    attr_reader :headers

    # Initialize a new request
    #
    # @example Initialize a new request with params and method
    #   Pxpayplus::Request.new(params: { param_key: 'param_val' }, method: :post)
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # Defines what fields in params should be used to sign the signature
    # @return [Array]
    def signature_fields
      [ :auth_binding_no, :req_time ]
    end

    # Returns a hash of filtered params fields and values to sign the signature
    # @return [Hash]
    def signature_params
      params.slice(*signature_fields)
    end

    # Signs the signature by signature_params
    # @return [String]
    def signature
      @signature ||= Pxpayplus.sign(signature_params.values.join)
    end

    # Returns headers to send in api request
    # @return [Hash]
    def headers
      {
        'Content-Type': 'application/json;charset=utf-8',
        'PX-MerCode': Pxpayplus.merchant_code,
        'PX-SignValue': signature
      }
    end

    # Sends the api request
    # @return [Hash] response body parsed from JSON
    def send_request
      response = RestClient::Request.execute(rest_client_params)
      parsed_body = JSON.parse(response.body)

      if parsed_body['status_code'] != '0000'
        raise Pxpayplus::Error.new(parsed_body['status_message'])
      end

      parsed_body

    rescue RestClient::Exceptions::Timeout => timeout_e
      raise 'Request Timed Out.'

    rescue RestClient::ExceptionWithResponse => non_200_e
      raise Pxpayplus::Error.new(non_200_e.response.body)

    rescue RuntimeError => unknown_e
      raise unknown_e.message
    end

    private

    # Returns params to send in RestClient request
    # @return [Hash]
    def rest_client_params
      rest_client_params = {
        method: method,
        url: url,
        payload: params,
        headers: headers
      }

      if method == :get
        rest_client_params.delete(:payload)
      end

      rest_client_params
    end
  end
end
