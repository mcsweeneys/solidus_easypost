module Spree
  module Calculator::Shipping
    module Usps
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        def self.service_api_name
          'noop'
        end
      end
    end
  end
end
