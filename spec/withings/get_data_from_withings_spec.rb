# frozen_string_literal: true

RSpec.describe AdhDiary::Withings::GetDataFromWithings do
  context "startdate" do
    it "generates a time at 00:00" do
      time = Time.utc(2025, 7, 1, 15, 37)
      expect(subject.startdate(time)).to eq(Time.utc(2025, 7, 1, 0, 0))
    end
  end

  context "enddate" do
    it "generates a time at 23:59" do
      time = Time.utc(2025, 7, 1, 15, 37)
      expect(subject.startdate(time)).to eq(Time.utc(2025, 7, 1, 0, 0))
    end
  end
end
