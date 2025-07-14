RSpec.feature "Medications", db: true do
  let(:user) do
    Factory.create(:user, name: "Some Guy")
  end

  context "unauthenticated user" do
    scenario "index redirects to login" do
      visit "/medications"

      expect(page).to have_content "Please log in"
    end

    scenario "new redirects to login" do
      visit "/medications/new"

      expect(page).to have_content "Please log in"
    end

    scenario "delete redirects to login" do
      medication = Factory.create(:medication)
      visit "/medications/#{medication.id}/delete"

      expect(page).to have_content "Please log in"
    end

    scenario "edit redirects to login" do
      medication = Factory.create(:medication)
      visit "/medications/#{medication.id}/edit"

      expect(page).to have_content "Please log in"
    end
  end

  context "authenticated user" do
    before(:each) do
      login_as user
    end

    scenario "index shows all medications" do
      Factory.create(:medication, name: "Lisdexamfetamin")
      visit "/medications"

      expect(page).to have_content "Lisdexamfetamin"
    end

    scenario "delete medication" do
      Factory.create(:medication, name: "Lisdexamfetamin")
      Factory.create(:medication, name: "Medikinet")

      visit "/medications"
      within all("tbody/tr")[1] do
        click_on "Destroy"
      end

      expect(page).to have_content "Delete Medikinet?"

      click_on("Confirm")
      expect(page).to have_content "Medication successfully deleted"
      expect(page).not_to have_content "Medikinet"
    end

    scenario "create medication" do
      visit "/medications"

      click_on("Add Medication")

      fill_in "medication[name]", with: "Lisdexamfetamin"

      click_on("Create")
      expect(page).to have_content "Medication successfully created"
      expect(page).to have_content "Lisdexamfetamin"
    end

    scenario "create invalid medication" do
      visit "/medications"

      click_on("Add Medication")

      click_on("Create")
      expect(page).to have_content "Medication could not be created"
      expect(page).to have_content "must be filled"
    end

    scenario "edit medication" do
      medication = Factory.create(:medication, name: "Lisdexamfetamin")
      visit "/medications/#{medication.id}/edit"

      fill_in "medication[name]", with: "Apple"

      click_on("Update")
      expect(page).to have_content "Medication successfully updated"
      expect(page).to have_content "Apple"
    end

    scenario "invalid edit medication" do
      medication = Factory.create(:medication, name: "Lisdexamfetamin")
      visit "/medications/#{medication.id}/edit"

      fill_in "medication[name]", with: ""

      click_on("Update")
      expect(page).to have_content "Medication could not be updated"
      expect(page).to have_content "must be filled"
    end
  end
end
