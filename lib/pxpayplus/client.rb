module Pxpayplus
  class Client
    def actions
      [ :create_auth_order, :debit, :unbind, :refund, :check_order_status, :update_debit_time ]
    end
  end
end