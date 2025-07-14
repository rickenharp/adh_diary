# frozen_string_literal: true

require "rspec"
require "mimemagic"
require "zip/filesystem"

RSpec.feature "Weekly Reports", db: true do
  include_context "report data"

  let(:time) { Time.parse("2025-07-14 12:00") }

  context "default entries" do
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
      within all("table.table tbody tr")[0] do
        click_on "PDF"
      end
      expect(page.response_headers["Content-Type"]).to match(%r{application/pdf})
      expect(page.response_headers["Content-Disposition"]).to eq("inline; filename=\"2025-W22.pdf\"")
      expect(MimeMagic.by_magic(page.body)).to eq("application/pdf")
    end
  end

  context "export" do
    scenario "PDF bulk export" do
      Hanami.app.container.stub("time", time)
      generate_entries(from: "2025-05-01", to: "2025-05-18")
      login_as(user)

      visit "/reports"

      check("2025-W17")
      check("2025-W19")

      click_on("Export")
      expect(MimeMagic.by_magic(page.body)).to eq("application/zip")
      expect(page.response_headers["Content-Type"]).to match(%r{application/zip})
      expect(page.response_headers["Content-Disposition"]).to eq("attachment; filename=\"export-2025-07-14-12-00.zip\"")
      Zip::File.open_buffer(page.body) do |zip_file|
        expect(zip_file.dir.entries(".")).to eq(["2025-W17.pdf", "2025-W19.pdf"])
        zip_file.dir.foreach(".") do |pdf_file_name|
          expect(MimeMagic.by_magic(zip_file.file.read(pdf_file_name))).to eq("application/pdf")
        end
      end
    end

    scenario "PDF bulk export with nothing selected" do
      generate_entries(from: "2025-05-01", to: "2025-05-18")
      login_as(user)

      visit "/reports"

      click_on("Export")
      expect(page).to have_content "Please select reports to export"
    end
  end
end
