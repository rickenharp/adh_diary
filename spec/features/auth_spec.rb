require "bcrypt"

RSpec.feature "Auth", db: true do
  let(:password) { "setec astronomy" }
  # let(:email) { "user@example.com" }
  let(:user) do
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    Factory.create(:user, name: "Some Guy", password_hash: password_hash, password_salt: password_salt)
  end

  before(:each) do
    user
  end

  scenario "visiting the entries page unauthenticated redirects to login" do
    visit "/entries"

    expect(page).to have_content "Please log in"
  end

  scenario "logging in works" do
    visit "/entries"

    fill_in "email", with: user.email
    fill_in "password", with: password
    within("form#login") do
      click_link_or_button("Log in")
    end

    expect(page).to have_content "Login successful"
  end
end
