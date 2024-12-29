module Pxpayplus
  class RequestDefinition

    class CreateAuthOrderRequest < Request
      def signature_fields; [:mer_order_no, :amount, :device_type, :req_time]; end
      def method; :post; end
      def url; "https://#{Pxpayplus.api_hostname}/CreateAuthOrder"; end
    end

    class DebitRequest < Request
      def signature_fields; [:mer_trade_no, :auth_binding_no, :mer_order_no, :amount, :req_time]; end
      def method; :post; end
      def url; "https://#{Pxpayplus.api_hostname}/Debit"; end
    end

    class UnbindRequest < Request
      def signature_fields; [:mer_order_no, :auth_binding_no, :mer_member_token, :req_time]; end
      def method; :post; end
      def url; "https://#{Pxpayplus.api_hostname}/Unbind"; end
    end

    class RefundRequest < Request
      def signature_fields; [:mer_trade_no, :px_trade_no, :refund_mer_trade_no, :amount, :req_time]; end
      def method; :post; end
      def url; "https://#{Pxpayplus.api_hostname}/Refund"; end
    end

    class CheckOrderStatusRequest < Request
      def signature_fields; [:mer_trade_no, :req_time]; end
      def method; :get; end
      def url; "https://#{Pxpayplus.api_hostname}/CheckOrderStatus/#{params[:mer_trade_no]}/#{params[:req_time]}"; end
    end

    class UpdateDebitTimeRequest < Request
      def signature_fields; [:mer_trade_no, :px_trade_no, :req_time]; end
      def method; :post; end
      def url; "https://#{Pxpayplus.api_hostname}/UpdateDebitTime"; end
    end

  end
end