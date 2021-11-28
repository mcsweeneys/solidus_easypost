require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def self.service_api_name
          'noop'
        end
      end
    end
  end
end
