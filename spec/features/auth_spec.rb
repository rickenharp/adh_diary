require "bcrypt"

RSpec.feature "Auth", db: true do
  let(:password) { "setec astronomy" }
  # let(:email) { "user@example.com" }
  let(:account) do
    password_hash = BCrypt::Password.create(password)
    Factory.create(:account, name: "Some Guy", password_hash: password_hash)
  end

  before(:each) do
    account
  end

  scenario "visiting the entries page unauthenticated redirects to login" do
    visit "/entries"

    expect(page).to have_content "Please log in"
  end

  scenario "logging in works" do
    visit "/entries"

    fill_in "email", with: account.email
    fill_in "password", with: password
    within("form#login") do
      click_link_or_button("Log in")
    end

    expect(page).to have_content "Login successful"
  end
end
