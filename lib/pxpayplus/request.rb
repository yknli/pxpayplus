require 'rest-client'
require 'json'

module Pxpayplus
  class Request

    attr_accessor :params, :method, :url, :headers

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

    def send_request
      rest_client_params = {
        method: method,
        url: url,
        payload: params,
        headers: headers
      }

      rest_client_params.delete(:payload) if method == :get

      response = RestClient::Request.execute(rest_client_params)
      parsed_body = JSON.parse(response.body)

      if parsed_body['status_code'] != '0000'
        raise Pxpayplus::Error.new(parsed_body['status_message'])
      end

      parsed_body

    rescue RestClient::ExceptionWithResponse => non_200_e
      raise Pxpayplus::Error.new(non_200_e.response.body)

    rescue RuntimeError => unknown_e
      raise unknown_e.message
    end
  end
end