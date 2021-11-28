module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailParcel < Spree::Calculator::Shipping::Usps::Base
        def self.service_api_name
          'USPS ParcelSelect'
        end

        def self.description
          I18n.t('spree.usps.first_class_mail_parcel')
        end

        protected
      end
    end
  end
end
