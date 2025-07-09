# frozen_string_literal: true

module AdhDiary
  module Actions
    module Entries
      EntrySchema = Dry::Schema.Params do
        required(:entry).hash do
          required(:date).filled(:date)
          required(:medication_schedule_id).filled(:integer)
          required(:attention).filled(:integer)
          required(:organisation).filled(:integer)
          required(:mood_swings).filled(:integer)
          required(:stress_sensitivity).filled(:integer)
          required(:irritability).filled(:integer)
          required(:restlessness).filled(:integer)
          required(:impulsivity).filled(:integer)
          optional(:side_effects)
          required(:blood_pressure).filled(:string)
          required(:weight).filled(:float)
        end
      end
    end
  end
end
