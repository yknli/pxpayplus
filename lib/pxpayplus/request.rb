require 'rest-client'
require 'json'

module Pxpayplus
  class Request

    attr_accessor :params, :method, :headers

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def signature_fields
      [ :auth_binding_no, :req_time ]
    end

    def signature_params
      params.slice(*signature_fields)
    end

    def signature
      @signature ||= Pxpayplus.sign(signature_params.values.join)
    end

    def headers
      {
        'Content-Type': 'application/json;charset=utf-8',
        'PX-MerCode': Pxpayplus.merchant_code,
        'PX-SignValue': signature
      }
    end

    def url
      "https://#{Pxpayplus.api_hostname}"
    end

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