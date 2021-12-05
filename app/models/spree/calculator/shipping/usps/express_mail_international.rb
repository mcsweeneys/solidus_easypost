module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMailInternational < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.express_mail_international')
        end
      end
    end
  end
end
