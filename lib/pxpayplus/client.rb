module Pxpayplus
  class Client
    def actions
      [ :create_auth_order, :debit, :unbind, :refund, :check_order_status, :update_debit_time ]
    end

    private

    # Converts a symbol of action name to request class name
    # @param [Object] api action name
    # @return [String] request class name
    def action_to_request_klass_name(action)
      klass_name = "#{action.to_s}_request"
      klass_name = klass_name.split('_').collect(&:capitalize).join
      "Pxpayplus::RequestDefinition::#{klass_name}"
    end
  end
end