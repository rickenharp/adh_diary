RSpec.feature "Withings integration", db: true do
  let(:account) { Factory.create(:account, name: "Some Guy", identities: []) }
  let(:identity_relation) { Hanami.app["relations.identities"] }
  let(:now) { Time.utc(2025, 7, 22, 14, 56) }
  let(:expiry) { now + 60 * 60 }
  let(:startdate) { Time.utc(2025, 7, 22, 0, 0) }
  let(:enddate) { Time.utc(2025, 7, 22, 23, 59) }

  around do |example|
    AdhDiary::Now.override!(now)
    WebMock.disable_net_connect!
    OmniAuth.config.test_mode = true
    old_validation_phase = OmniAuth.config.request_validation_phase
    OmniAuth.config.request_validation_phase = nil
    Hanami.app.container.stub("settings", OpenStruct.new(withings_client_id: "xxclientidxx", withings_client_secret: "xxclientsecretxx")) do
      example.run
    end
    OmniAuth.config.request_validation_phase = old_validation_phase
    OmniAuth.config.test_mode = false
    WebMock.enable_net_connect!
    AdhDiary::Now.reset!
  end

  before(:each) do
    OmniAuth.config.mock_auth[:withings] = OmniAuth::AuthHash.new({
      provider: "withings",
      uid: "1234567890",
      credentials: {
        token: "initial token",
        refresh_token: "initial refresh token",
        expires_at: expiry
      }
    })
  end

  scenario "creating an identity" do
    login_as(account)
    visit "/"

    expect { click_button("Connect with Withings") }.to change { identity_relation.where(account_id: account.id, provider: "withings").count }.by(1)
    identity = identity_relation.where(account_id: account.id, provider: "withings").one!

    expect(identity).to include(token: "initial token", refresh_token: "initial refresh token", uid: "1234567890")

    expect(page).to have_content "Successfully connected to Withings"
  end

  context "with fresh token" do
    scenario "getting data from withings" do
      identity = Factory[
        :identity,
        account: account,
        provider: "withings",
        token: "initial token",
        refresh_token: "initial refresh token",
        expires_at: expiry
      ]
      expect(identity.expires_at).to eq(expiry)

      account.identities << identity

      login_as(account)

      stub_request(:post, "https://wbsapi.withings.net/measure?action=getmeas&category=1&enddate=#{enddate.to_i}&meastypes=1,9,10&startdate=#{startdate.to_i}")
        .with(
          headers: {
            "Authorization" => "Bearer initial token"
          }
        )
        .to_return(status: 200, body: measure_body(weight: 60.5, systolic: 110, diastolic: 70), headers: {})
      visit "/entries/new"

      expect(page).to have_field("Weight", with: "60.5")
      expect(page).to have_field("Blood Pressure", with: "110/70")
    end
  end

  context "with expired token" do
    let(:expiry) { now - 60 * 60 }
    scenario "getting data from withings" do
      identity = Factory.create(
        :identity,
        account: account,
        provider: "withings",
        token: "initial token",
        refresh_token: "initial refresh token",
        expires_at: expiry
      )
      account.identities << identity

      login_as(account)

      stub_request(:post, "https://wbsapi.withings.net/v2/oauth2/")
        .with(
          body: {
            "action" => "requesttoken",
            "client_id" => "xxclientidxx",
            "client_secret" => "xxclientsecretxx",
            "grant_type" => "refresh_token",
            "refresh_token" => "initial refresh token"
          },
          headers: {
            "Authorization" => "Basic Og==",
            "Content-Type" => "application/x-www-form-urlencoded"
          }
        )
        .to_return(status: 200, body: refresh_body, headers: {"content-type" => "application/json"})

      stub_request(:post, "https://wbsapi.withings.net/measure?action=getmeas&category=1&enddate=#{enddate.to_i}&meastypes=1,9,10&startdate=#{startdate.to_i}")
        .with(
          headers: {
            "Authorization" => "Bearer fresh token"
          }
        )
        .to_return(status: 200, body: measure_body(weight: 60.5, systolic: 110, diastolic: 70), headers: {})

      visit "/entries/new"

      expect(page).to have_field("Weight", with: "60.5")
      expect(page).to have_field("Blood Pressure", with: "110/70")
    end
  end

  def measure_body(weight:, systolic:, diastolic:)
    <<~JSON
          {
        "status": 0,
        "body": {
          "measuregrps": [
            {
              "measures": [
                {
                  "value": #{diastolic * 1_000},
                  "type": 9,
                  "unit": -3,
                  "algo": 0,
                  "fm": 3
                },
                {
                  "value": #{systolic * 1_000},
                  "type": 10,
                  "unit": -3,
                  "algo": 0,
                  "fm": 3
                }
              ]
            },
            {
              "measures": [
                {
                  "value": #{weight * 1_000},
                  "type": 1,
                  "unit": -3,
                  "algo": 3,
                  "fm": 3
                }
              ]
            }
          ]
        }
      }
    JSON
  end

  def refresh_body
    <<~JSON
      {
        "status": 0,
        "body": {
          "accountid": 1,
          "access_token": "fresh token",
          "refresh_token": "fresh refresh token",
          "scope": "account.info,account.metrics,account.activity",
          "expires_in": 10800,
          "token_type": "Bearer"
        }
      }
    JSON
  end
end
