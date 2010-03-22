module AdaptivePay
  class Response

    def initialize(interface, type, response)
      @type = type
      @base_page_url = interface.base_page_url
      @attributes = {}
      parse response
    end

    def success?
      !!@success
    end

    def failure?
      !@success
    end

    def created?
      return false unless @attributes.has_key? "paymentExecStatus"
      payment_exec_status == "CREATED"
    end

    def pending?
      return false unless @attributes.has_key? "paymentExecStatus"
      payment_exec_status == "PENDING"
    end

    def completed?
      return false unless @attributes.has_key? "paymentExecStatus"
      payment_exec_status == "COMPLETED"
    end


    def payment_page_url
      case @type
      when :preapproval
        "#{@base_page_url}/webscr?cmd=_ap-preapproval&preapprovalkey=#{URI.escape(preapproval_key)}"
      when :payment
        "#{@base_page_url}/webscr?cmd=_ap-payment&paykey=#{URI.escape(pay_key)}"
      end
    end

    def read_attribute(name)
      @attributes[name]
    end

    def method_missing(name, *args)
      attribute = name.to_s.camelize
      attribute[0] = attribute.first.downcase

      if @attributes.has_key?(attribute)
        @attributes[attribute]
      else
        super
      end
    end

    protected
      def parse(response)
        unless response.code.to_s == "200"
          @success = false
          return
        end

        response.body.to_s.split("&").each do |fragment|
          k, v = fragment.split("=")
          @attributes[k] = URI.unescape(v)
        end

        @success = %w{Success SuccessWithWarning}.include?(read_attribute("responseEnvelope.ack"))
      end

  end
end
