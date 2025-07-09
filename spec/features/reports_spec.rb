# frozen_string_literal: true

require "rspec"

RSpec.feature "Entries", db: true do
  let(:password) { "password" }
  let(:user) { Factory.create(:user) }
  let(:medication) { Factory.create(:medication, name: "Lisdexamfetamin") }
  let(:medication_schedule) { Factory.create(:medication_schedule, medication: medication, morning: 30, user: user) }

  before(:each) do
    login_as(user)
  end

  scenario "visiting the reports page shows an entry" do
    start_date = Date.parse("2025-06-02")
    end_date = Date.parse("2025-06-15")
    (start_date..end_date).each do |date|
      Factory.create(:entry, date: date, user: user, medication_schedule: medication_schedule)
    end

    visit "/reports"

    expect(page).to have_content "2025-W22"
    expect(page).to have_content "2025-W23"
  end

  scenario "visiting the report detail page shows an entry" do
    start_date = Date.parse("2025-06-02")
    end_date = Date.parse("2025-06-15")
    (start_date..end_date).each do |date|
      Factory.create(:entry, date: date, user: user, medication_schedule: medication_schedule)
    end

    visit "/reports/2025-W22"

    expect(page).to have_content "from 2025-06-02 to 2025-06-08"
    expect(page).to have_content "Blood Pressure"
    expect(page).to have_content "Weight"
    expect(page).to have_link "2025-W23", href: "/reports/2025-W23"
  end
end
