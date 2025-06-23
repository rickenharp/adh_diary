# frozen_string_literal: true

require "rspec"
require "bcrypt"

RSpec.feature "Entries", db: true do
  let(:password) { "password" }
  let(:user) do
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    Factory.create(:user, name: "Some Guy", password_hash: password_hash, password_salt: password_salt)
  end

  before(:each) do
    visit "/login"
    fill_in "email", with: user.email
    fill_in "password", with: password
    click_on("Log in")
  end

  scenario "visiting the reports page shows an entry" do
    start_date = Date.parse("2025-06-02")
    end_date = Date.parse("2025-06-15")
    (start_date..end_date).each do |date|
      Factory.create(:entry, date: date, user: user)
    end

    visit "/reports"

    expect(page).to have_content "2025-W22"
    expect(page).to have_content "2025-W23"
  end

  scenario "visiting the reports page shows an entry" do
    start_date = Date.parse("2025-06-02")
    end_date = Date.parse("2025-06-15")
    (start_date..end_date).each do |date|
      Factory.create(:entry, date: date, user: user)
    end

    visit "/reports/2025-W22"

    expect(page).to have_content "from 2025-06-02 to 2025-06-08"
    expect(page).to have_content "Blood Pressure"
    expect(page).to have_content "Weight"
    expect(page).to have_link "2025-W23", href: "/reports/2025-W23"
  end
end
