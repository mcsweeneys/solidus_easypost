module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailParcel < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.first_class_mail_parcel')
        end
      end
    end
  end
end
