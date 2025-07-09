# frozen_string_literal: true

RSpec.describe AdhDiary::Views::Parts::MedicationSchedule do
  subject { described_class.new(value:) }
  let(:value) do
    double(
      "medication_schedule",
      medication: double("medication", name: "Lisdexamfetamin"),
      morning: 30.0,
      noon: 0,
      evening: 0,
      before_bed: 0
    )
  end

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end
end
