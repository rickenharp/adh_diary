require "bcrypt"

RSpec.describe "AuthenticationSpec", :db, type: :request do
  context "when action inherits from authenticated action" do
    context "when user is logged in" do
      let(:password) { "setec astronomy" }
      let!(:user) do
        Factory[:user, name: "Guy", email: "my@guy.com"]
      end

      it "succeeds" do
        login_as user

        get "/entries"

        expect(last_response.status).to be(200)
      end
    end

    context "when there is no user" do
      it "rejects the request, redirects" do
        get "/entries"

        expect(last_response).to be_redirect
      end
    end
  end
end
