# frozen_string_literal: true

require "rack/test"

module RodauthTestHelper
  def login_as(email, password)
    visit "/sign-in"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Login"
    expect(page).to have_content "You have been logged in"
  end
end

RSpec.shared_context "Rack::Test" do
  # Define the app for Rack::Test requests
  let(:app) { Hanami.app }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include_context "Rack::Test", type: :request
  config.include RodauthTestHelper, type: :request
  config.include RodauthTestHelper, type: :feature
  # config.before(:each, type: :request) { AdhDiary::App.prepare(:warden) }
  # config.before(:each, type: :feature) { AdhDiary::App.prepare(:warden) }
  # config.after(:each, type: :request) { Warden.test_reset! }
  # config.after(:each, type: :feature) { Warden.test_reset! }
end
