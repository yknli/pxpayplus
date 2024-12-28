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
  end
end