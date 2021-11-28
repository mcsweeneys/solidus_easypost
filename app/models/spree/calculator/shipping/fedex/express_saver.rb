require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Fedex
      class ExpressSaver < Spree::Calculator::Shipping::Fedex::Base
        def self.service_api_name
          'FedEx FEDEX_EXPRESS_SAVER'
        end

        def self.description
          I18n.t('spree.fedex.express_saver')
        end
      end
    end
  end
end
