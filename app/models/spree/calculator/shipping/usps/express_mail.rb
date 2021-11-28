module Spree
  module Calculator::Shipping
    module Usps
      class ExpressMail < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.express_mail')
        end

        def self.service_api_name
          'USPS Express'
        end
      end
    end
  end
end
