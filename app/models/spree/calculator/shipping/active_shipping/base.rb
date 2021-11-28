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

          return nil unless rate
          rate = rate.to_f + (Spree::ActiveShipping::Config[:handling_fee].to_f || 0.0)
        end

        def timing(line_items)
          order = line_items.first.order
          # TODO: Figure out where stock_location is supposed to come from.
          # TODO: Figure out what this method actually does.
          origin = ::EasyPost::Address.create(
            street1: origin.address1,
            street2: origin.address2,
            city: origin.city,
            state: origin.state,
            zip: origin.postal_code,
            country: origin.country.code(:alpha2).value
          )

          addr = order.ship_address
          destination = ::EasyPost::Address.create(
            street1: destination.address1,
            street2: destination.address2,
            city: destination.city,
            state: destination.state,
            zip: destination.postal_code,
            country: destination.country.code(:alpha2).value
          )

          timings_result = Rails.cache.fetch(cache_key(package) + '-timings') do
            retrieve_timings(origin, destination, packages(order))
          end
          raise timings_result if timings_result.is_a?(Spree::ShippingError)
          return nil if timings_result.nil? || !timings_result.is_a?(Hash) || timings_result.empty?
          timings_result[description]
        end

        private

        def package_builder
          @package_builder ||= Spree::PackageBuilder.new
        end

        def retrieve_rates(origin, destination, shipment_packages)
          to_address = EasyPost::Address.create(
            street1: destination.address1,
            street2: destination.address2,
            city: destination.city,
            state: destination.state,
            zip: destination.postal_code,
            country: destination.country.code(:alpha2).value
          )

          from_address = EasyPost::Address.create(
            street1: origin.address1,
            street2: origin.address2,
            city: origin.city,
            state: origin.state,
            zip: origin.postal_code,
            country: origin.country.code(:alpha2).value
          )

          parcel = EasyPost::Parcel.create(
            weight: shipment_packages.first.weight.to_f
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

          return rate_hash
        # TODO: Deal with the API failures here. This isn't in ActiveShipping any longer!
        rescue ::ActiveShipping::Error => e
          if [::ActiveShipping::ResponseError].include?(e.class) && e.response.is_a?(::ActiveShipping::Response)
            params = e.response.params
            if params.key?('Response') && params['Response'].key?('Error') && params['Response']['Error'].key?('ErrorDescription')
              message = params['Response']['Error']['ErrorDescription']
            # Canada Post specific error message
            elsif params.key?('eparcel') && params['eparcel'].key?('error') && params['eparcel']['error'].key?('statusMessage')
              message = e.response.params['eparcel']['error']['statusMessage']
            else
              message = e.message
            end
          else
            message = e.message
          end

          error = Spree::ShippingError.new("#{I18n.t('spree.shipping_error')}: #{message}")
          Rails.cache.write @cache_key, error # write error to cache to prevent constant re-lookups
          raise error
        end

        def retrieve_timings(origin, destination, packages)
          if carrier.respond_to?(:find_time_in_transit)
            response = carrier.find_time_in_transit(origin, destination, packages)
            return response
          end
        rescue ::ActiveShipping::ResponseError => re
          if re.response.is_a?(::ActiveShipping::Response)
            params = re.response.params
            if params.key?('Response') && params['Response'].key?('Error') && params['Response']['Error'].key?('ErrorDescription')
              message = params['Response']['Error']['ErrorDescription']
            else
              message = re.message
            end
          else
            message = re.message
          end

          error = Spree::ShippingError.new("#{I18n.t('spree.shipping_error')}: #{message}")
          Rails.cache.write @cache_key + '-timings', error # write error to cache to prevent constant re-lookups
          raise error
        end

        def cache_key(package)
          stock_location = package.stock_location.nil? ? '' : "#{package.stock_location.id}-"
          order = package.order
          ship_address = package.order.ship_address
          contents_hash = Digest::MD5.hexdigest(package.contents.map { |content_item| content_item.variant.id.to_s + '_' + content_item.quantity.to_s }.join('|'))
          @cache_key = "#{stock_location}-#{order.number}-#{ship_address.country.iso}-#{fetch_best_state_from_address(ship_address)}-#{ship_address.city}-#{ship_address.zipcode}-#{contents_hash}-#{I18n.locale}".delete(' ')
        end

        def fetch_best_state_from_address(address)
          address.state ? address.state.abbr : address.state_name
        end

        def build_location(address)
          ::EasyPost::Address.create(
            street1: address.address1,
            street2: address.address2,
            city: address.city,
            state: address.state,
            zip: address.zipcode,
            country: address.country.iso
          )

          # ::ActiveShipping::Location.new(country: address.country.iso,
          #                                state: fetch_best_state_from_address(address),
          #                                city: address.city,
          #                                zip: address.zipcode)
        end

        def retrieve_rates_from_cache(package, origin, destination)
          Rails.cache.fetch(cache_key(package)) do
            shipment_packages = package_builder.process(package)
            # shipment_packages = packages(package)
            if shipment_packages.empty?
              {}
            else
              retrieve_rates(origin, destination, shipment_packages)
            end
          end
        end
      end
    end
  end
end
