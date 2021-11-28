require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class PriorityOvernight < Spree::Calculator::Shipping::Fedex::Base
        def self.service_api_name
          'FedEx PRIORITY_OVERNIGHT'
        end

        def self.description
          I18n.t('spree.fedex.priority_overnight')
        end
      end
    end
  end
end
