require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class Ground < Spree::Calculator::Shipping::Fedex::Base
        def self.service_api_name
          'FedEx FEDEX_GROUND'
        end

        def self.description
          "FedEx Ground"
        end
      end
    end
  end
end
