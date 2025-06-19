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

  scenario "visiting the entries page shows an entry" do
    Factory.create(:entry, date: "2025-06-09")
    visit "/entries"

    expect(page).to have_content "2025-06-09"
  end

  scenario "creating a valid entry" do
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-08"
    choose "entry[attention]", option: "0"
    choose "entry[organisation]", option: "1"
    choose "entry[mood_swings]", option: "2"
    choose "entry[stress_sensitivity]", option: "3"
    choose "entry[irritability]", option: "4"
    choose "entry[restlessness]", option: "5"
    choose "entry[impulsivity]", option: "4"
    fill_in("Side effects", with: "Omniscience")
    fill_in("Blood pressure", with: "122/70")
    fill_in("Weight", with: "126.7")

    click_on("Create")

    expect(page).to have_content "Entry created"
    expect(page).to have_content "2025-06-08"
    expect(page).to have_selector "td.attention", text: "0"
    expect(page).to have_selector "td.organisation", text: "1"
    expect(page).to have_selector "td.mood-swings", text: "2"
    expect(page).to have_selector "td.stress-sensitivity", text: "3"
    expect(page).to have_selector "td.irritability", text: "4"
    expect(page).to have_selector "td.restlessness", text: "5"
    expect(page).to have_selector "td.impulsivity", text: "4"
    expect(page).to have_selector "td.blood-pressure", text: "122/70"
    expect(page).to have_selector "td.weight", text: "126.7"
  end

  scenario "creating an entry with existing date" do
    Factory.create(:entry, date: "2025-06-09")
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-09"
    choose "entry[attention]", option: "0"
    choose "entry[organisation]", option: "1"
    choose "entry[mood_swings]", option: "2"
    choose "entry[stress_sensitivity]", option: "3"
    choose "entry[irritability]", option: "4"
    choose "entry[restlessness]", option: "5"
    choose "entry[impulsivity]", option: "4"
    fill_in("Side effects", with: "Omniscience")
    fill_in("Blood pressure", with: "122/70")
    fill_in("Weight", with: "126.7")

    click_on("Create")

    expect(page).to have_content "Could not create entry"
    expect(page).to have_content "already exists"
  end

  scenario "creating an  invalid entry" do
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-08"

    click_on("Create")

    expect(page).to have_content "Could not create entry"
    expect(page).to have_field "Date", with: "2025-06-08"
    expect(page).to have_field "Weight", with: ""
  end
end
