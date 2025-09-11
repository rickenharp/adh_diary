# frozen_string_literal: true

RSpec.describe AdhDiary::Action do
  include Warden::Test::Helpers

  let(:params) { {"warden" => double("warden", user: double("user", locale: "en"))} }
  let(:i18n) { spy("i18n", default_locale: :en) }
  subject { described_class.new(i18n: i18n) }

  before do
    allow(i18n).to receive(:locale=)
  end

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end

  it "sets the locale" do
    subject.call(params)
    expect(i18n).to have_received(:locale=).with(:en)
  end
end
