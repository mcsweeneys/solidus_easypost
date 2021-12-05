module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailInternationalLargeFlatRateBox < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.priority_mail_international_large_flat_rate_box')
        end
      end
    end
  end
end
