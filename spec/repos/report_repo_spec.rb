# frozen_string_literal: true

RSpec.describe AdhDiary::Repos::ReportRepo, db: true do
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
        result = subject.weekly.to_a

        expect(result.map(&:week)).to eq ["2025-W26"]
      end

      it "returns available weeks, week only" do
        result = subject.weeks.to_a

        expect(result).to eq ["2025-W26"]
      end

      it "returns the wanted week" do
        result = subject.get_week("2025-W26")

        expect(result.week).to eq "2025-W26"
      end
    end

    it "orders the blood pressure" do
      report = subject.get_week("2025-W26")
      expect(report.blood_pressure).to eq(%w[0 1 2 3 4 5 6])
    end

    it "returns the weights" do
      report = subject.get_week("2025-W26")

      expect(report.weights).to contain_exactly(100.1, 101.2, 101.6, 100.7, 100.3, 100.9, 101.2)
    end
  end

  context "with lalala null weight values" do
    before do
      Enumerator.new do |yielder|
        loop do
          yielder.yield rand(99.0..101.0)
        end
      end
      generate_entries(
        from: "2025-01-01",
        to: "2025-02-28",
        additional_data: {blood_pressure: (1..), weight: (1..)}
      )
    end

    describe "months" do
      it "returns available months" do
        result = subject.monthly.to_a

        expect(result.map(&:month)).to eq ["2025-01", "2025-02"]
      end
    end

    it "orders the blood pressure" do
      report = subject.get_month("2025-01")
      expect(report.blood_pressure.to_a).to eq(
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14",
          "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27",
          "28", "29", "30", "31"]
      )
    end

    it "returns the last weight" do
      report = subject.get_month("2025-02")
      expect(report.weight).to eq(59.0)
    end

    it "returns the weights" do
      report = subject.get_month("2025-02")
      expect(report.weights.to_a).to eq((32..59).map(&:to_f).to_a)
    end
  end
end
