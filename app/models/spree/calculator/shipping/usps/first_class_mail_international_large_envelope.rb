module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternationalLargeEnvelope < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.first_class_mail_international_large_envelope')
        end
      end
    end
  end
end


