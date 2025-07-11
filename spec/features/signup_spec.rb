RSpec.feature "Signup", db: true do
  let(:password) { "setec astronomy" }
  let(:email) { "user@example.com" }
  let(:name) { "Some Guy" }

  scenario "signing up works" do
    visit "/users/new"

    fill_in "user[name]", with: name
    fill_in "user[email]", with: email
    fill_in "user[password]", with: password
    fill_in "user[password_confirmation]", with: password

    click_link_or_button("Log in")

    expect(page).to have_content "Please log in"
  end
end
