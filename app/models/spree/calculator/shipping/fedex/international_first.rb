require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class InternationalFirst < Spree::Calculator::Shipping::Fedex::Base
        def self.service_api_name
          'FedEx FIRST_OVERNIGHT'
        end

        def self.description
          I18n.t('spree.fedex.intl_first')
        end
      end
    end
  end
end
