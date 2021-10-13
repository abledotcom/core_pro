# frozen_string_literal: true

require 'base64'
require 'http/rest_client'

# CorePro HTTP API Client
module CorePro
  # Base endpoint resources class
  class Resource < OpenStruct
    extend HTTP::RestClient::DSL

    endpoint(ENV['COREPRO_ENDPOINT'] || 'https://api.corepro.io')
    content_type 'application/json'
    basic_auth(user: ENV['COREPRO_KEY'], pass: ENV['COREPRO_SECRET'])

    # Resource collection finder, uses the default limit
    #
    # @param params [Hash] URI parameters to pass to the endpoint.
    # @return [Array] of [Object] instances
    def self.all(filers = [], params = {})
      objectify(request(:get, uri(:list, *filers), params: params))
    end

    # Resource finder
    #
    # @param id [String] resource indentifier
    # @param params [Hash] URI parameters to pass to the endpoint.
    # @return [Object] instance
    def self.find(id, params = {})
      objectify(request(:get, uri(:get, id), params: params))
    end

    # Resource creation helper
    #
    # @param params [Hash] request parameters to pass to the endpoint as JSON.
    # @return [Object] instance
    def self.create(params = {})
      objectify(request(:post, uri(:create), json: params))
    end

    # Resource update helper
    #
    # @param id [String] resource indentifier
    # @param params [Hash] request parameters to pass to the endpoint as JSON.
    # @return [Object] instance
    def self.update(id, params = {})
      objectify(request(:patch, uri(:update, id), json: params))
    end

    # Resource constructor wrapper
    #
    # @param payload [Hash] response payload to build a resource.
    # @return [Object] instance or a list of instances.
    def self.objectify(payload)
      if payload['data'].is_a?(Array)
        return payload['data'].map { |data| new(data) }
      end

      return new(payload['data']) if payload['data'].is_a?(Hash)

      payload
    end

    # Returns the ID name based on the resource type
    #
    # @return [String]
    def resource_id
      resource_name = self.class.name.to_s.split('::').last
      resource_name[0] = resource_name[0].downcase
      "#{resource_name}Id"
    end

    # Helper to reload a resource
    #
    # @return [CorePro::Resource]
    def reload
      self.class.find(send(resource_id))
    end

    # Extracts the error message from the response
    #
    # @param response [HTTP::Response] the server response
    # @param parsed_response [Object] the parsed server response
    #
    # @return [String]
    def self.extract_error(response, parsed_response)
      parsed_response['errors'] || super(response, parsed_response)
    end

    # Validate error response
    #
    # Looks at the response code by default.
    #
    # @param response [HTTP::Response] the server response
    # @param parsed_response [Object] the parsed server response
    #
    # @return [TrueClass] if status code is not a successful standard value
    def self.error_response?(response, parsed_response)
      !(200..299).cover?(response.code) && parsed_response['errors'].any?
    end
  end

  # Customer endpoint resource
  class Program < Resource
    path '/program'
  end

  # Customer endpoint resource
  class Customer < Resource
    path '/customer'

    # Performs a customer KYC/onboarding
    #
    # See: https://docs.corepro.io/reference#4-run-kyc-on-the-customer
    #
    # @return [Customer] instance
    def onboard(kyc_vendor)
      onboard_uri = self.class.uri(:onboard, kyc_vendor, :all)

      self.class.objectify(
        self.class.request(
          :post,
          onboard_uri,
          json: { customerId: customerId }
        )
      )
    end
  end

  # Accounts endpoint resource
  class Account < Resource
    path '/account'
  end

  # External account endpoint resource
  class ExternalAccount < Resource
    path '/externalAccount'
  end
end
