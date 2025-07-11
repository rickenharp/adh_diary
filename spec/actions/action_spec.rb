# frozen_string_literal: true

RSpec.describe AdhDiary::Action do
  include Warden::Test::Helpers
  let(:params) { {"warden" => double("warden", user: double("user", locale: "en"))} }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end

  it "sets the locale" do
    i18n_spy = spy("i18n")
    stub_const("::I18n", i18n_spy)
    allow(I18n).to receive(:locale)
    subject.call(params)
    expect(i18n_spy).to have_received(:locale=).with(:en)
  end
end
