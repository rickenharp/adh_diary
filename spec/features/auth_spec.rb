require "bcrypt"

RSpec.feature "Auth", db: true do
  let(:password) { "setec astronomy" }
  # let(:email) { "user@example.com" }
  let(:account) do
    Factory.create(:account, name: "Some Guy", password: password)
  end

  before(:each) do
    account
  end

  scenario "visiting the entries page unauthenticated redirects to login" do
    visit "/entries"

    expect(page).to have_content "Please login to continue"
  end

  scenario "logging in works" do
    visit "/entries"

    fill_in "login", with: account.email
    fill_in "password", with: password
    within("form#login-form") do
      click_link_or_button # ("submit")
    end

    expect(page).to have_content "You have been logged in"
  end
end
