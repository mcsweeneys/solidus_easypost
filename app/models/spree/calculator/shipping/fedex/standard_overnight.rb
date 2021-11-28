module Spree
  module Calculator::Shipping
    module Fedex
      class StandardOvernight < Spree::Calculator::Shipping::Fedex::Base
        def self.service_api_name
          'FedEx STANDARD_OVERNIGHT'
        end

        def self.description
          I18n.t('spree.fedex.standard_overnight')
        end
      end
    end
  end
end
