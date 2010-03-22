require "net/http"
require "net/https"

module AdaptivePay
  class IpnValidationRequest
    attr_accessor :request_body, :response

    def self.response_type
      :ipn_validation
    end

    def initialize(request_body)
      @request_body = request_body
    end
    
    def perform(interface)
      uri = construct_uri(interface)
      
      request = Net::HTTP::Post.new uri.request_uri
      request.body = build_request_body
      http_response = build_http(uri).request request
      @response = http_response.body
    end
    
    protected
    
    def build_request_body
      "cmd=_notify-validate&" + @request_body
    end
    
    def construct_uri(interface)
      URI.parse("#{interface.base_page_url}/cgi-bin/webscr")
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.port == 443)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
  end
end
