require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module CanadaPostPws
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
      end
    end
  end
end
