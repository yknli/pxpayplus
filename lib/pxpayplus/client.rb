module Pxpayplus
  class Client
    def actions
      [ :create_auth_order, :debit, :unbind, :refund, :check_order_status, :update_debit_time ]
    end

    private

    # Converts a symbol of action name to request class name
    # @param [String] api action name
    # @return [String] request class name
    def action_to_request_klass_name(action)
      klass_name = "#{action.to_s}_request"
      klass_name = klass_name.split('_').collect(&:capitalize).join
      "Pxpayplus::RequestDefinition::#{klass_name}"
    end

    # Converts a string of a request class name to the actual class
    # @param [String] request class name
    # @return [Class] request class
    def constantize_request_klass(klass_name)
      Object.const_get(klass_name)
    end

    # Sends api request by calling given api action
    def method_missing(method, *args)
      if actions.include?(method)
        klass_name = action_to_request_klass_name(method)
        klass = constantize_request_klass(klass_name)

        params = {}
        params = args[0] if args.length > 0

        req = klass.new(params: params)
        req.send_request
      else
        super
      end
    end
  end
end