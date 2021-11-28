module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternationalLargeEnvelope < Spree::Calculator::Shipping::Usps::Base
        def self.service_api_name
          raise
        end

        def self.description
          I18n.t('spree.usps.first_class_mail_international_large_envelope')
        end

        protected

        # weight limit in ounces or zero (if there is no limit)
        def max_weight_for_country(country)
          # if weight in ounces > 64, then First Class Mail International Large Envelope is not available for the order
          # https://www.usps.com/ship/first-class-package-international-service.htm?
          return WEIGHT_LIMITS[country.iso]
        end
      end
    end
  end
end


