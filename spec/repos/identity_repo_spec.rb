# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::IdentityRepo, db: true do
  include_context "report data"

  user_provider = Object.new.extend(Dry::Effects::Handler.Reader(:user, as: :call))

  around do |example|
    user_provider.call(user, &example)
  end

  it "upserts an identity" do
    now = Time.now
    sooner = now + 60 * 60 * 1
    later = now + 60 * 60 * 2
    old_identity = subject.create(user_id: 1, provider: "myprovider", uid: "7", token: "a token", expires_at: sooner)
    subject.upsert(user_id: 1, provider: "myprovider", uid: "7", token: "a newer token", expires_at: later)

    expect(subject.count(provider: "myprovider")).to eq(1)
    identity = subject.by_id(old_identity.id)
    expect(identity.token).to eq("a newer token")
    expect(identity.expires_at.to_i).to eq(later.utc.to_i)
  end
end
