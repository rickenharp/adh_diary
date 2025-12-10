# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::WeeklyReportRepo, db: true do
  include_context "report data"

  around do |example|
    Hanami.app.container.stub("current_account", account) do
      example.run
    end
  end

  context "with no null weight values" do
    before do
      generate_entries(
        from: "2025-06-23",
        to: "2025-06-29",
        additional_data: {blood_pressure: (0..), weight: [100.1, 101.2, 101.6, 100.7, 100.3, 100.9, 101.2]}
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

    it "returns the latest weight entry" do
      report = subject.get("2025-W26")
      expect(report.weight).to eq(101.2)
    end
  end

  context "with a null weight value" do
    before do
      generate_entries(
        from: "2025-06-23",
        to: "2025-06-29",
        additional_data: {blood_pressure: (0..), weight: [100.1, 101.2, 101.6, 100.7, 100.3, 100.9, nil]}
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

    it "returns the latest weight entry" do
      report = subject.get("2025-W26")
      expect(report.weight).to eq(100.9)
    end
  end
end
