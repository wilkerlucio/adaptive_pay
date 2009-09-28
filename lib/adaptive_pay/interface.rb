require "erb"

module AdaptivePay
  class Interface

    attr_accessor :base_url, :environment, :username, :password, :signature

    def initialize(rails_env=nil)
      load(rails_env||Rails.env) unless rails_env == false
    end

    def load(rails_env)
      config = YAML.load(ERB.new(File.read(File.join(Rails.root, "config/adaptive_pay.yml"))).result)[rails_env.to_s]
      if config["retain_requests_for_test"] == true
        @retain_requests_for_test = true
      else
        set_environment config.delete("environment")
        config.each do |k, v|
          send "#{k}=", v
        end
      end
    end

    def set_environment(environment)
      @environment = environment.to_sym
      @base_url = {
        :production => "https://svcs.paypal.com/AdaptivePayments/",
        :sandbox => "https://svcs.sandbox.paypal.com/AdaptivePayments/",
        :beta_sandbox => "https://svcs.beta-sandbox.paypal.com/AdaptivePayments/"
      }[@environment]
    end

    def queue_requests_for_test?
      !!@queue_requests_for_test
    end

  end
end
