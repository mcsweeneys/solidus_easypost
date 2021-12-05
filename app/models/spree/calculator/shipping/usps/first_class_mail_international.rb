module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassMailInternational < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.first_class_mail_international')
        end
      end
    end
  end
end


