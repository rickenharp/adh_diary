RSpec.feature "Medication schedules", db: true do
  let(:account) do
    Factory.create(:account, name: "Some Guy")
  end

  let(:other_account) do
    Factory.create(:account, name: "Some Other Guy")
  end

  let(:medication) do
    Factory.create(:medication, name: "Lisdexamfetamin")
  end

  context "unauthenticated account" do
    scenario "index redirects to login" do
      visit "/medication_schedules"

      expect(page).to have_content "Please log in"
    end

    scenario "new redirects to login" do
      visit "/medication_schedules/new"

      expect(page).to have_content "Please log in"
    end

    scenario "delete redirects to login" do
      medication_schedule = Factory.create(:medication_schedule)
      visit "/medication_schedules/#{medication_schedule.id}/delete"

      expect(page).to have_content "Please log in"
    end

    scenario "edit redirects to login" do
      medication_schedule = Factory.create(:medication_schedule, account: account, medication: medication)
      visit "/medication_schedules/#{medication_schedule.id}/edit"

      expect(page).to have_content "Please log in"
    end
  end

  context "authenticated account" do
    before(:each) do
      login_as account
    end

    scenario "index shows all medication_schedules" do
      Factory.create(:medication_schedule, account: account, medication: medication)
      Factory.create(:medication_schedule, account: other_account, medication: medication, morning: 70)

      visit "/medication_schedules"

      expect(page).to have_content "Lisdexamfetamin 30 0 0 0"
      expect(page).to_not have_content "Lisdexamfetamin 70 0 0 0"
    end

    scenario "delete medication schedule" do
      Factory.create(
        :medication_schedule,
        account: account,
        medication: medication,
        morning: 30,
        noon: 0,
        evening: 0,
        before_bed: 0
      )

      visit "/medication_schedules"

      within all("tbody/tr")[0] do
        click_on "Destroy"
      end

      expect(page).to have_content "Delete Lisdexamfetamin 30-0-0-0?"

      click_on("Confirm")
      expect(page).to have_content "Medication schedule deleted"
      expect(page).not_to have_content "Lisdexamfetamin 30 0 0 0"
    end

    scenario "create medication schedule" do
      medication
      visit "/medication_schedules"

      click_on("Add Medication Schedule")

      select "Lisdexamfetamin", from: "medication_schedule[medication_id]"

      click_on("Create")
      expect(page).to have_content "Medication schedule successfully created"
      expect(page).to have_content "Lisdexamfetamin"
    end

    scenario "create invalid medication schedule" do
      visit "/medication_schedules"

      click_on("Add Medication Schedule")
      fill_in "medication_schedule[morning]", with: nil

      click_on("Create")
      expect(page).to have_content "Medication schedule could not be created"
      expect(page).to have_content "must be filled"
    end

    scenario "edit medication schedule" do
      medication_schedule = Factory.create(:medication_schedule, medication: medication, account: account, morning: 30)
      visit "/medication_schedules/#{medication_schedule.id}/edit"

      fill_in "medication_schedule[morning]", with: 40

      click_on("Update")
      expect(page).to have_content "Medication schedule successfully updated"
      expect(page).to have_content "40"
    end

    scenario "invalid edit medication" do
      medication_schedule = Factory.create(:medication_schedule, medication: medication, account: account, morning: 30)
      visit "/medication_schedules/#{medication_schedule.id}/edit"

      fill_in "medication_schedule[morning]", with: nil

      click_on("Update")
      expect(page).to have_content "Medication schedule could not be updated"
      expect(page).to have_content "must be filled"
    end
  end
end
