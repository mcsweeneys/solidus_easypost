module Spree
  module Calculator::Shipping
    module Usps
      class StandardPost < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.standard_post')
        end
      end
    end
  end
end
