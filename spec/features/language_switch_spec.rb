# frozen_string_literal: true

require "rspec"

RSpec.feature "Switch language", db: true do
  let(:user) { Factory.create(:user) }

  before(:each) do
    login_as(user)
  end

  scenario "switching the language works" do
    visit "/?foo=bar"
    click_on("German")
    expect(page).to have_content "Willkommen"
    expect(page).to have_current_path "/?foo=bar"
  end

  scenario "switching to an invalid language" do
    visit "/"
    visit "/language/xx"

    expect(page).to have_content "Welcome"
    expect(page).to have_content "Could not change language"
  end
end
