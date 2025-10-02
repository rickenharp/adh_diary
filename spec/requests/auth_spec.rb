require "bcrypt"

RSpec.describe "AuthenticationSpec", :db, type: :request do
  context "when action inherits from authenticated action" do
    context "when account is logged in" do
      let(:password) { "setec astronomy" }
      let!(:account) do
        Factory[:account, name: "Guy", email: "my@guy.com"]
      end

      it "succeeds" do
        login_as account

        get "/entries"

        expect(last_response.status).to be(200)
      end
    end

    context "when there is no account" do
      it "rejects the request, redirects" do
        get "/entries"

        expect(last_response).to be_redirect
      end
    end
  end
end
