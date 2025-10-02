# frozen_string_literal: true

require "rspec"

RSpec.feature "Entries JS", db: true, js: true do
  let(:password) { "password" }
  let(:account) { Factory.create(:account) }

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
    # Hanami.app.container.stub("withings.get_measurements", ->(_) { Success({}) })
    medication_schedule

    login_as(account)
  end

  # after(:each) do
  #   Hanami.app.container.unstub("withings.get_measurements")
  # end

  scenario "dismissing notification" do
    entry = Factory.create(:entry, date: "2025-06-09", account: account, medication_schedule: medication_schedule)
    visit "/entries/#{entry.id}/edit"
    click_on("Update")
    expect(page).to have_content "Entry successfully updated"
    page.find("button.delete").click
    expect(page).to_not have_content "Entry successfully updated"
  end
end
