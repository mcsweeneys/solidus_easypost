module Spree
  module Calculator::Shipping
    module Usps
      class MediaMail < Spree::Calculator::Shipping::Usps::Base
        def self.service_api_name
          'USPS MediaMail'
        end

        def self.description
          I18n.t('spree.usps.media_mail')
        end
      end
    end
  end
end
