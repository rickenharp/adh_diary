# frozen_string_literal: true

require "rack/test"

RSpec.shared_context "Rack::Test" do
  # Define the app for Rack::Test requests
  let(:app) { Hanami.app }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include_context "Rack::Test", type: :request
  config.include Warden::Test::Helpers, type: :request
  config.before(:each, type: :request) { AdhDiary::App.prepare(:warden) }
  config.before(:each, type: :feature) { AdhDiary::App.prepare(:warden) }
  config.after(:each, type: :request) { Warden.test_reset! }
end
