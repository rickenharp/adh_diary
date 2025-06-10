# frozen_string_literal: true

RSpec.describe AdhDiary::Actions::Entries::Create do
  let(:params) { {entry: {}} }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
