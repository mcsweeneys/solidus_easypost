module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMailInternational < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.priority_mail_international')
        end
      end
    end
  end
end
