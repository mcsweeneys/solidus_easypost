module Spree
  module Calculator::Shipping
    module Fedex
      class TwoDay < Spree::Calculator::Shipping::Fedex::Base
        def self.service_api_name
          'FedEx FEDEX_2_DAY'
        end

        def self.description
          I18n.t('spree.fedex.two_day')
        end
      end
    end
  end
end
