# frozen_string_literal: true

require "dry/types"

module AdhDiary
  Types = Dry.Types

  module Types
    # Define your custom types here
    Strength = Types::String.enum(
      "gar nicht" => 0,
      "leicht" => 1,
      "mäßig" => 2,
      "mittel" => 3,
      "stärker" => 4,
      "stark" => 5
    )
  end
end
