# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::WeeklyReportRepo, db: true do
  include_context "report data"

  account_provider = Object.new.extend(Dry::Effects::Handler.Reader(:account, as: :call))

  around do |example|
    account_provider.call(account, &example)
  end

  before do
    generate_entries(
      from: "2025-06-23",
      to: "2025-06-29",
      additional_data: {blood_pressure: (0..)}
    )
  end

  describe "weeks" do
    it "returns available weeks" do
      result = subject.weeks

      expect(result.map(&:week)).to eq ["2025-W26"]
    end
  end

  it "orders the blood pressure" do
    report = subject.get("2025-W26")
    expect(report.blood_pressure).to eq(%w[0 1 2 3 4 5 6])
  end
end
