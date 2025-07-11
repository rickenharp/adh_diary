# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::WeeklyReportRepo, db: true do
  let(:user) { Factory.create(:user) }

  user_provider = Object.new.extend(Dry::Effects::Handler.Reader(:user, as: :call))

  around do |example|
    user_provider.call(user, &example)
  end

  before do
    start_date = Date.parse("2025-06-23")
    end_date = Date.parse("2025-06-29")

    medication = Factory.create(:medication)
    medication_schedule = Factory.create(:medication_schedule, user: user, medication: medication)
    (start_date..end_date).each_with_index do |date, i|
      Factory.create(:entry, user: user, date: date, medication_schedule: medication_schedule, blood_pressure: i)
    end
  end

  describe "weeks" do
    it "returns available weeks" do
      result = subject.weeks

      expect(result.map(&:week)).to eq ["2025-W25"]
    end
  end

  it "orders the blood pressure" do
    report = subject.get("2025-W25")
    expect(report.blood_pressure).to eq("0,1,2,3,4,5,6")
  end
end
