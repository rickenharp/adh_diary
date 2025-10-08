require "ostruct"

RSpec.shared_context "report data", shared_context: :db do
  let(:password) { "password" }
  let(:account) { Factory.create(:account, password: password) }
  let(:medication) { Factory.create(:medication) }
  let(:medication_schedule) { Factory.create(:medication_schedule, account: account, medication: medication) }

  # "Your scientists were so preoccupied with whether or not they could, they didn't stop to think if they should."
  let(:additional_data_class) do
    Class.new do
      attr_reader :additional_data
      def initialize(additional_data)
        @additional_data = additional_data.each_with_object({}) do |(k, v), hash|
          nextable = Struct.new(:next)
          new_value = case v
          in Enumerable
            v.to_enum
          else
            nextable.new(next: v)
          end
          hash[k] = new_value
        end
      end

      def next
        additional_data.each_with_object({}) { |(k, v), hash| hash[k] = v.next }
      end
    end
  end

  def generate_entries(from: "2025-06-02", to: "2025-06-15", additional_data: {})
    additional_data_provider = additional_data_class.new(additional_data)

    (Date.parse(from)..Date.parse(to)).each do |date|
      Factory.create(:entry, date: date, account: account, medication_schedule: medication_schedule, **additional_data_provider.next)
    end
  end
end
