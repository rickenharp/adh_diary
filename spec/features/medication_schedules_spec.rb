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

    scenario "new redirects to login" do
      visit "/medication_schedules/new"

      expect(page).to have_content "Please log in"
    end

    xscenario "delete redirects to login" do
      medication_schedule = Factory.create(:medication_schedule)
      visit "/medication_schedules/#{medication_schedule.id}/delete"

      expect(page).to have_content "Please log in"
    end

    scenario "edit redirects to login" do
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

    xscenario "delete medication schedule" do
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

    scenario "create medication schedule" do
      medication
      visit "/medication_schedules"

      click_on("Add Medication Schedule")

      select "Lisdexamfetamin", from: "medication_schedule[medication_id]"

      click_on("Create")
      expect(page).to have_content "Medication schedule was successfully created"
      expect(page).to have_content "Lisdexamfetamin"
    end

    scenario "create invalid medication" do
      visit "/medication_schedules"

      click_on("Add Medication Schedule")
      fill_in "medication_schedule[morning]", with: nil

      click_on("Create")
      expect(page).to have_content "Could not create medication schedule"
      expect(page).to have_content "must be filled"
    end

    scenario "edit medication schedule" do
      medication_schedule = Factory.create(:medication_schedule, medication: medication, user: user, morning: 30)
      visit "/medication_schedules/#{medication_schedule.id}/edit"

      fill_in "medication_schedule[morning]", with: 40

      click_on("Update")
      expect(page).to have_content "Medication schedule successfully updated"
      expect(page).to have_content "40"
    end

    scenario "invalid edit medication" do
      medication_schedule = Factory.create(:medication_schedule, medication: medication, user: user, morning: 30)
      visit "/medication_schedules/#{medication_schedule.id}/edit"

      fill_in "medication_schedule[morning]", with: nil

      click_on("Update")
      expect(page).to have_content "Could not update medication schedule"
      expect(page).to have_content "must be filled"
    end
  end
end
