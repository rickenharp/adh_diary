RSpec.feature "Medication schedules", db: true do
  let(:user) do
    Factory.create(:user, name: "Some Guy")
  end

  let(:medication) do
    Factory.create(:medication, name: "Lisdexamfetamin")
  end

  context "unauthenticated user" do
    scenario "index redirects to login" do
      visit "/medication_schedules"

      expect(page).to have_content "Please log in"
    end

    xscenario "new redirects to login" do
      visit "/medication_schedules/new"

      expect(page).to have_content "Please log in"
    end

    xscenario "delete redirects to login" do
      medication = Factory.create(:medication)
      visit "/medication_schedules/#{medication.id}/delete"

      expect(page).to have_content "Please log in"
    end

    xscenario "edit redirects to login" do
      medication_schedule = Factory.create(:medication_schedule, user: user, medication: medication)
      visit "/medication_schedules/#{medication_schedule.id}/edit"

      expect(page).to have_content "Please log in"
    end
  end

  context "authenticated user" do
    before(:each) do
      login_as user
    end

    scenario "index shows all medication_schedules" do
      Factory.create(:medication_schedule, user: user, medication: medication)
      visit "/medication_schedules"

      expect(page).to have_content "Lisdexamfetamin 30 0 0 0"
    end

    xscenario "delete medication" do
      Factory.create(:medication, name: "Lisdexamfetamin")
      Factory.create(:medication, name: "Medikinet")

      visit "/medications"
      within all("tbody/tr")[1] do
        click_on "Delete"
      end

      expect(page).to have_content "Delete Medikinet?"

      click_on("Confirm")
      expect(page).to have_content "Medication deleted"
      expect(page).not_to have_content "Medikinet"
    end

    xscenario "create medication" do
      visit "/medications"

      click_on("Add Medication")

      fill_in "medication[name]", with: "Lisdexamfetamin"

      click_on("Create")
      expect(page).to have_content "Medication was successfully created"
      expect(page).to have_content "Lisdexamfetamin"
    end

    xscenario "create invalid medication" do
      visit "/medications"

      click_on("Add Medication")

      click_on("Create")
      expect(page).to have_content "Could not create medication"
      expect(page).to have_content "must be filled"
    end

    xscenario "edit medication" do
      medication = Factory.create(:medication, name: "Lisdexamfetamin")
      visit "/medications/#{medication.id}/edit"

      fill_in "medication[name]", with: "Apple"

      click_on("Update")
      expect(page).to have_content "Medication successfully updated"
      expect(page).to have_content "Apple"
    end

    xscenario "invalid edit medication" do
      medication = Factory.create(:medication, name: "Lisdexamfetamin")
      visit "/medications/#{medication.id}/edit"

      fill_in "medication[name]", with: ""

      click_on("Update")
      expect(page).to have_content "Could not update medication"
      expect(page).to have_content "must be filled"
    end
  end
end
