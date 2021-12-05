module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailInternationalSmallFlatRateBox < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.priority_mail_international_small_flat_rate_box')
        end
      end
    end
  end
end
