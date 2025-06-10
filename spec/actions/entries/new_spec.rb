# frozen_string_literal: true

RSpec.describe AdhDiary::Actions::Entries::New do
  let(:params) { {} }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
