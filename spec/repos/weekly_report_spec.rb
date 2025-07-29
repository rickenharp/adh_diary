# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::WeeklyReportRepo, db: true do
  include_context "report data"

  user_provider = Object.new.extend(Dry::Effects::Handler.Reader(:user, as: :call))

  around do |example|
    user_provider.call(user, &example)
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
