module AdaptivePay
  class PaymentDetailsRequest < AbstractPaymentRequest

    def self.response_type
      :payment_details
    end

    def self.endpoint
      "PaymentDetails"
    end

    attribute "payKey"
    attribute "transactionId"
    attribute "trackingId"

  end
end
