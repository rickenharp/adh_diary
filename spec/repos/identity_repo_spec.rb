# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::IdentityRepo, db: true do
  include_context "report data"

  account_provider = Object.new.extend(Dry::Effects::Handler.Reader(:account, as: :call))

  around do |example|
    account_provider.call(account, &example)
  end

  it "upserts an identity" do
    now = Time.now
    sooner = now + 60 * 60 * 1
    later = now + 60 * 60 * 2
    old_identity = subject.create(account_id: 1, provider: "myprovider", uid: "7", token: "a token", expires_at: sooner)
    subject.upsert(account_id: 1, provider: "myprovider", uid: "7", token: "a newer token", expires_at: later)

    expect(subject.count(provider: "myprovider")).to eq(1)
    identity = subject.by_id(old_identity.id)
    expect(identity.token).to eq("a newer token")
    expect(identity.expires_at.to_i).to eq(later.utc.to_i)
  end
end
