module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMail < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.express_mail')
        end
      end
    end
  end
end
