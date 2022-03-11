# This is a base calculator for shipping calcualations using the ActiveShipping plugin.  It is not intended to be
# instantiated directly.  Create subclass for each specific shipping method you wish to support instead.
#
# Digest::MD5 is used for cache_key generation.
require 'digest/md5'
require 'easypost'
require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module ActiveShipping
      class Base < ShippingCalculator
        def self.service_name
          description
        end

        def available?(package)
          !compute(package).nil?
        rescue Spree::ShippingError
          false
        end

        def compute_package(package)
          order = package.order

          stock_location = package.stock_location

          origin = stock_location
          destination = order.ship_address

          rates_result = retrieve_rates_from_cache(package, origin, destination)

          return nil if rates_result.is_a?(Spree::ShippingError)
          return nil if rates_result.empty?
          rate = rates_result[self.class.description]

          rate.present? ? rate.to_f : nil
        end

        private

        def retrieve_rates(origin, destination, shipment_package)
          Rails.logger.debug { "EasyPost API Key: #{EasyPost.api_key}" }
          ensure_easypost_api_key_set!
          Rails.logger.debug { "EasyPost API Key: #{EasyPost.api_key}" }

          to_address = EasyPost::Address.create(
            street1: destination.address1,
            street2: destination.address2,
            city: destination.city,
            state: destination.state,
            zip: destination.zipcode,
            country: destination.country.iso
          )

          from_address = EasyPost::Address.create(
            street1: origin.address1,
            street2: origin.address2,
            city: origin.city,
            state: origin.state,
            zip: origin.zipcode,
            country: origin.country.iso
          )

          parcel = EasyPost::Parcel.create(
            weight: shipment_package.weight.to_f * Spree::ActiveShipping::Config[:unit_multiplier]
          )

          shipment = EasyPost::Shipment.create(
            :to_address => to_address,
            :from_address => from_address,
            :parcel => parcel,
            options: {
              special_rates_eligibility: 'USPS.MEDIAMAIL'
            }
          )

          rates = shipment.rates.map{|r| ["#{r.carrier} #{r.service}", r.rate]}
          rate_hash = Hash[*rates.flatten]

          Rails.logger.debug { "EasyPost Rates: #{rate_hash}" }

          return rate_hash
        rescue StandardError => e
          Rails.logger.debug { "EasyPost Error: #{e} / #{e.message}" }
          error = Spree::ShippingError.new("#{I18n.t('spree.shipping_error')}: #{e.message}")
          Rails.cache.write @cache_key, error # write error to cache to prevent constant re-lookups
          raise error
        end

        def cache_key(package)
          stock_location = package.stock_location.nil? ? '' : "#{package.stock_location.id}-"
          order = package.order
          ship_address = package.order.ship_address
          contents_hash = Digest::MD5.hexdigest(package.contents.map { |content_item| content_item.variant.id.to_s + '_' + content_item.quantity.to_s }.join('|'))
          @cache_key = "#{stock_location}-#{order.number}-#{ship_address.country.iso}-#{fetch_best_state_from_address(ship_address)}-#{ship_address.city}-#{ship_address.zipcode}-#{contents_hash}-#{I18n.locale}-easypost".delete(' ')
        end


        def fetch_best_state_from_address(address)
          address.state ? address.state.abbr : address.state_name
        end

        def retrieve_rates_from_cache(package, origin, destination)
          Rails.cache.fetch(cache_key(package)) do
            if package.empty?
              {}
            else
              retrieve_rates(origin, destination, package)
            end
          end
        end

        private

        # A bit obtuse way to ensure the EasyPost API key is set, but this enables us to
        # avoid doing weird loading in the parent application and/or this gem.
        def ensure_easypost_api_key_set!
          Rails.logger.debug { "Ensuring EasyPost API Key is set. Value from Solidus: #{Spree::ActiveShipping::Config[:easypost_api_key]}" }
          EasyPost.api_key = Spree::ActiveShipping::Config[:easypost_api_key]
        end
      end
    end
  end
end
