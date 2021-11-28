module Spree
  module Calculator::Shipping
    module Usps
      class PriorityMail < Spree::Calculator::Shipping::Usps::Base
        def self.service_api_name
          'USPS Priority'
        end

        def self.description
          I18n.t('spree.usps.priority_mail')
        end
      end
    end
  end
end
