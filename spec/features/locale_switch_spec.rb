# frozen_string_literal: true

require "rspec"

RSpec.feature "Switch locale", db: true do
  context "logged in" do
    let(:user) { Factory.create(:user) }

    before(:each) do
      login_as(user)
    end

    scenario "switching the locale works" do
      visit "/?foo=bar"
      select("German")
      click_on("Choose")
      expect(page).to have_content "Willkommen"
      expect(page).to have_current_path "/?foo=bar"
    end
  end

  context "logged out" do
    scenario "switching the locale works" do
      visit "/?foo=bar"
      select("German")
      click_on("Choose")
      expect(page).to have_content "Willkommen"
      expect(page).to have_current_path "/?foo=bar"
    end
  end
end
