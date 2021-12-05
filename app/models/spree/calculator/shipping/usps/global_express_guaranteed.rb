module Spree
  module Calculator::Shipping
    module Usps
      class GlobalExpressGuaranteed < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.global_express_guaranteed')
        end
      end
    end
  end
end
