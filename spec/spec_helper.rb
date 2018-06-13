require 'json'
require 'rspec_command'
require 'uri'
require 'vcr'

module SensitiveDataFilter
  private

  def serializable_body(*)
    body = super
    body['string'].gsub!(/"access_token":\s*"\w+"/, '"access_token": "<<AGENT_OKTA_TOKEN>>"')
    body['string'].gsub!(/"ip_address":\s*"[\d\.]+"/, '"ip_address": "127.0.0.1"')
    body['string'].gsub!(/#{URI.parse(test_okta_endpoint).host}/, 'my-okta.okta.com')
    body['string'].gsub!(/#{test_okta_github_admins}/i, 'okta_github_admins')
    body['string'].gsub!(/#{test_okta_github_users}/i, 'okta_github_users')
    body['string'].gsub!(/#{test_github_token}/i, '<<AGENT_GITHUB_TOKEN>>')
    body
  end
end

VCR::Response.include(SensitiveDataFilter)
VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = 'spec/cassettes/'
  config.hook_into :faraday

  config.default_cassette_options = {
    serialize_with: :json,
    decode_compressed_response: true,
    record: ENV['TRAVIS'] ? :none : :once
  }

  config.filter_sensitive_data('https://my-okta.okta.com/api/v1') do
    test_okta_endpoint
  end

  config.filter_sensitive_data('<<GITHUB_TOKEN>>') do
    test_github_token
  end

  config.filter_sensitive_data('<<OKTA_TOKEN>>') do
    test_okta_token
  end

  # Forces binary to be readable and modifiable json
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end

require 'oktakit'

module OktaTestClient
  extend RSpec::SharedContext
  let(:okta_client) { Oktakit::Client.new(token: test_okta_token, api_endpoint: test_okta_endpoint) }
end

RSpec.configure do |config|
  config.include OktaTestClient
  config.include RSpecCommand
end

def test_github_token
  ENV.fetch 'GITHUB_TEST_TOKEN', 'x' * 40
end

def test_okta_endpoint
  ENV.fetch('OKTA_TEST_ENDPOINT', 'https://my-okta.okta.com/api/v1')
end

def test_okta_token
  ENV.fetch('OKTA_TEST_TOKEN', 'x' * 40)
end

def test_okta_github_users
  ENV.fetch('OKTA_TEST_USER_GROUP', 'okta_github_users')
end

def test_okta_github_admins
  ENV.fetch('OKTA_TEST_ADMIN_GROUP', 'okta_github_admins')
end
