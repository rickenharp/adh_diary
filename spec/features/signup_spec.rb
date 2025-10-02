RSpec.feature "Signup", db: true do
  let(:password) { "setec astronomy" }
  let(:email) { "user@example.com" }
  let(:name) { "Some Guy" }

  scenario "signing up works" do
    visit "/accounts/new"

    fill_in "account[name]", with: name
    fill_in "account[email]", with: email
    fill_in "account[password]", with: password
    fill_in "account[password_confirmation]", with: password

    click_link_or_button("Log in")

    expect(page).to have_content "Please log in"
  end
end
