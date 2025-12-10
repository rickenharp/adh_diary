# frozen_string_literal: true

require "rspec"

RSpec.feature "Entries", db: true do
  let(:password) { "password" }
  let(:account) { Factory.create(:account, password: password) }

  let(:lisdexamfetamin) { Factory.create(:medication, name: "Lisdexamfetamin") }
  let(:medication_schedule) do
    Factory.create(
      :medication_schedule,
      medication: lisdexamfetamin,
      morning: 30,
      account: account
    )
  end

  around(:each) do |example|
    Hanami.app.container.stub("withings.get_measurements", ->(_) { Success({}) }) do
      example.run
    end
  end

  before(:each) do
    medication_schedule

    # visit "/sign-in"
    # fill_in "Email", :with => account.email
    # fill_in "Password", :with => password
    # click_on "Login"
    login_as(account.email, password)
  end

  scenario "visiting the entries page shows an entry" do
    Factory.create(:entry, date: "2025-06-09", account: account)
    visit "/entries"

    expect(page).to have_content "2025-06-09"
  end

  scenario "creating a valid entry" do
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-08"
    select "Lisdexamfetamin 30-0-0-0", from: "entry[medication_schedule_id]"
    choose "entry[attention]", option: "0"
    choose "entry[organisation]", option: "1"
    choose "entry[mood_swings]", option: "2"
    choose "entry[stress_sensitivity]", option: "3"
    choose "entry[irritability]", option: "4"
    choose "entry[restlessness]", option: "5"
    choose "entry[impulsivity]", option: "4"
    fill_in("Side Effects", with: "Omniscience")
    fill_in("Blood Pressure", with: "122/70")
    fill_in("Weight", with: "126.7")

    click_on("Create")

    expect(page).to have_content "Entry successfully created"
    expect(page).to have_content "2025-06-08"
    expect(page).to have_selector "td.attention", text: "none"
    expect(page).to have_selector "td.organisation", text: "mild"
    expect(page).to have_selector "td.mood-swings", text: "moderate"
    expect(page).to have_selector "td.stress-sensitivity", text: "medium"
    expect(page).to have_selector "td.irritability", text: "stronger"
    expect(page).to have_selector "td.restlessness", text: "sever"
    expect(page).to have_selector "td.impulsivity", text: "stronger"
    expect(page).to have_selector "td.blood-pressure", text: "122/70"
    expect(page).to have_selector "td.weight", text: "126.7"
  end

  scenario "creating a valid entry without weight" do
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-08"
    select "Lisdexamfetamin 30-0-0-0", from: "entry[medication_schedule_id]"
    choose "entry[attention]", option: "0"
    choose "entry[organisation]", option: "1"
    choose "entry[mood_swings]", option: "2"
    choose "entry[stress_sensitivity]", option: "3"
    choose "entry[irritability]", option: "4"
    choose "entry[restlessness]", option: "5"
    choose "entry[impulsivity]", option: "4"
    fill_in("Side Effects", with: "Omniscience")
    fill_in("Blood Pressure", with: "122/70")
    fill_in("Weight", with: nil)

    click_on("Create")

    expect(page).to have_content "Entry successfully created"
    expect(page).to have_content "2025-06-08"
    expect(page).to have_selector "td.attention", text: "none"
    expect(page).to have_selector "td.organisation", text: "mild"
    expect(page).to have_selector "td.mood-swings", text: "moderate"
    expect(page).to have_selector "td.stress-sensitivity", text: "medium"
    expect(page).to have_selector "td.irritability", text: "stronger"
    expect(page).to have_selector "td.restlessness", text: "sever"
    expect(page).to have_selector "td.impulsivity", text: "stronger"
    expect(page).to have_selector "td.blood-pressure", text: "122/70"
    expect(page).to have_selector "td.weight", text: "-"
  end

  scenario "creating an entry with existing date" do
    Factory.create(:entry, date: "2025-06-09", account: account)
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-09"
    select "Lisdexamfetamin 30-0-0-0", from: "entry[medication_schedule_id]"
    choose "entry[attention]", option: "0"
    choose "entry[organisation]", option: "1"
    choose "entry[mood_swings]", option: "2"
    choose "entry[stress_sensitivity]", option: "3"
    choose "entry[irritability]", option: "4"
    choose "entry[restlessness]", option: "5"
    choose "entry[impulsivity]", option: "4"
    fill_in("Side Effects", with: "Omniscience")
    fill_in("Blood Pressure", with: "122/70")
    fill_in("Weight", with: "126.7")

    click_on("Create")

    expect(page).to have_content "Entry could not be created"
    expect(page).to have_content "already exists"
  end

  scenario "creating an invalid entry" do
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-08"

    click_on("Create")

    expect(page).to have_content "Entry could not be created"
    expect(page).to have_field "Date", with: "2025-06-08"
    expect(page).to have_content "is missing"
  end

  scenario "editing an entry" do
    entry = Factory.create(:entry, date: "2025-06-09", account: account, medication_schedule: medication_schedule)

    visit "/entries/#{entry.id}/edit"

    expect(page).to have_field "Date", with: "2025-06-09"
    expect(page).to have_select "Medication schedule", with_options: ["Lisdexamfetamin 30-0-0-0"]

    fill_in "entry[side_effects]", with: "Death"

    click_on("Update")

    expect(page).to have_content "Entry successfully updated"

    visit "/entries/#{entry.id}"

    expect(page).to have_content "Death"
  end

  scenario "editing an entry invalidly" do
    Factory.create(:entry, date: "2025-06-08", account: account, medication_schedule: medication_schedule)
    entry = Factory.create(:entry, date: "2025-06-09", account: account, medication_schedule: medication_schedule)

    visit "/entries/#{entry.id}/edit"

    expect(page).to have_field "Date", with: "2025-06-09"
    expect(page).to have_select "Medication schedule", with_options: ["Lisdexamfetamin 30-0-0-0"]

    fill_in "entry[date]", with: "2025-06-08"

    click_on("Update")
    expect(page).to have_content "Entry could not be updated"
    expect(page).to have_content "already exists"
  end

  scenario "set a weight to null" do
    Factory.create(:entry, date: "2025-06-08", account: account, medication_schedule: medication_schedule)
    entry = Factory.create(:entry, date: "2025-06-09", account: account, medication_schedule: medication_schedule)

    visit "/entries/#{entry.id}/edit"

    expect(page).to have_field "Date", with: "2025-06-09"
    expect(page).to have_select "Medication schedule", with_options: ["Lisdexamfetamin 30-0-0-0"]

    fill_in "entry[weight]", with: nil

    click_on("Update")
    expect(page).to have_content "Entry successfully updated"
  end

  scenario "remember last used medication schedule" do
    Factory.create(
      :medication_schedule,
      medication: lisdexamfetamin,
      morning: 40,
      account: account
    )
    visit "/entries/new"

    fill_in "entry[date]", with: "2025-06-09"
    select "Lisdexamfetamin 40-0-0-0", from: "entry[medication_schedule_id]"
    choose "entry[attention]", option: "0"
    choose "entry[organisation]", option: "1"
    choose "entry[mood_swings]", option: "2"
    choose "entry[stress_sensitivity]", option: "3"
    choose "entry[irritability]", option: "4"
    choose "entry[restlessness]", option: "5"
    choose "entry[impulsivity]", option: "4"
    fill_in("Side Effects", with: "Omniscience")
    fill_in("Blood Pressure", with: "122/70")
    fill_in("Weight", with: "126.7")

    click_on("Create")

    visit "/entries/new"

    expect(page).to have_select("entry[medication_schedule_id]", selected: "Lisdexamfetamin 40-0-0-0")
  end
end
