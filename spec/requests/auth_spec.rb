RSpec.describe "AuthenticationSpec", :db, type: :request do
  context "when action inherits from authenticated action" do
    context "when account is logged in" do
      let!(:account) do
        Factory[:account, name: "John Mastodon", email: "john.mastodon@example.com"]
      end

      it "succeeds" do
        env "rack.session", {account_id: account.id}

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
