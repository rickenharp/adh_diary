# frozen_string_literal: true

require "rspec"

RSpec.feature "Home" do
  scenario "visiting the entries page shows an entry" do
    Factory.create(:entry, date: "2025-06-09")
    visit "/entries"

    expect(page).to have_content "Entry for 2025-06-09"
  end
end
