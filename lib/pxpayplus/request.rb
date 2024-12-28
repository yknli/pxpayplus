module Pxpayplus
  class Request

    attr_accessor :params, :method, :url

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def signature
      @signature ||= Pxpayplus.sign(params.values.join)
    end
  end
end