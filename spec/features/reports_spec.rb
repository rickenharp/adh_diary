# frozen_string_literal: true

require "rspec"
require "mimemagic"

RSpec.feature "Weekly Reports", db: true do
  include_context "report data"

  before(:each) do
    login_as(user)
    generate_entries
  end

  scenario "visiting the reports page shows an entry" do
    visit "/reports"

    expect(page).to have_content "2025-W22"
    expect(page).to have_content "2025-W23"
  end

  scenario "visiting the report detail page shows an entry" do
    visit "/reports/2025-W22"

    expect(page).to have_content "from 2025-06-02 to 2025-06-08"
    expect(page).to have_content "Blood Pressure"
    expect(page).to have_content "Weight"
    expect(page).to have_link "2025-W23", href: "/reports/2025-W23"
  end

  scenario "PDF generation" do
    visit "/reports"

    within all("tbody/tr")[0] do
      click_on "PDF"
    end
    expect(page.response_headers["Content-Type"]).to match(%r{application/pdf})
    expect(page.response_headers["Content-Disposition"]).to eq("inline; filename=\"2025-W22.pdf\"")
    expect(MimeMagic.by_magic(page.body)).to eq("application/pdf")
  end
end
