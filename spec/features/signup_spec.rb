RSpec.feature "Signup", db: true do
  let(:password) { "setec astronomy" }
  let(:email) { "user@example.com" }
  let(:name) { "Some Guy" }

  scenario "signing up works" do
    visit "/"
    click_link_or_button "Sign up"

    fill_in "name", with: name
    fill_in "login", with: email
    fill_in "password", with: password

    click_link_or_button("Create Account")
    expect(page).to have_content "An email has been sent to you with a link to verify your account"
    match = /^(https?:.*?) $/.match(Mail::TestMailer.deliveries.last.body.to_s)
    expect(match).to be_truthy
    verify_url = URI(match[1])
    visit verify_url.request_uri
    click_link_or_button("Verify Account")
    expect(page).to have_content "Your account has been verified"

    click_link_or_button "Log out"
    click_link_or_button "Log in"

    fill_in "login", with: email
    fill_in "password", with: password

    click_link_or_button("Login")

    expect(page).to have_content "You have been logged in"
  end
end
