# frozen_string_literal: true

RSpec.describe AdhDiary::Actions::Entries::Show, db: true do
  let(:entry) { Factory.create(:entry, date: "2025-06-09") }
  let(:params) { {id: entry.id} }

  context "With existing entry" do
    it "it is successful" do
      response = subject.call(params)
      expect(response).to be_successful
    end
  end

  context "Without existing entry" do
    let(:params) { {} }
    it "it is successful" do
      response = subject.call(params)
      expect(response).to be_not_found
    end
  end
end
