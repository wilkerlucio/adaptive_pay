module AdaptivePay
  class PreapprovalDetailsRequest < AbstractPaymentRequest

    def self.response_type
      :preapproval_details
    end

    def self.endpoint
      "PreapprovalDetails"
    end

    attribute "getBillingAddress"
    attribute "preapprovalKey"

  end
end
