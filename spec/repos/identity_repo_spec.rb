# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::IdentityRepo, db: true do
  include_context "report data"

  user_provider = Object.new.extend(Dry::Effects::Handler.Reader(:user, as: :call))

  around do |example|
    user_provider.call(user, &example)
  end

  it "does something" do
    subject.create(user_id: 1, provider: "myprovider", uid: "7", token: "a token")
    subject.upsert(user_id: 1, provider: "myprovider", uid: "7", token: "a token")

    expect(subject.count(provider: "myprovider")).to eq(1)
  end
end
