module Spree
  module Calculator::Shipping
    module Usps
      class FirstClassPackageInternational < Spree::Calculator::Shipping::Usps::Base
        def self.description
          I18n.t('spree.usps.first_class_package_international')
        end
      end
    end
  end
end
