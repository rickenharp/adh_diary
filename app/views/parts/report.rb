# auto_register: false
# frozen_string_literal: true

require "gruff"

module AdhDiary
  module Views
    module Parts
      class Report < AdhDiary::Views::Part
        def medication
          Array(value.medication).join(", ")
        end

        def from
          value.from.strftime("%d.%m.%Y")
        end

        def to
          value.to.strftime("%d.%m.%Y")
        end

        def systolic_chart_data
          value.blood_pressure.map { (it == "0") ? nil : it.split("/").map(&:to_i).first }
        end

        def diastolic_chart_data
          value.blood_pressure.map { (it == "0") ? nil : it.split("/").map(&:to_i).last }
        end

        def dates_chart_data
          value.dates.map(&:to_s)
        end

        def blood_pressure_chart_image
          g = Gruff::Line.new
          g.theme = theme
          g.title = "Blutdruck"

          g.marker_font_size = 12
          g.reference_lines[:sys_normal] = {value: 119, color: "#a6ce39"}
          g.reference_lines[:sys_elevated] = {value: 129, color: "#ffec00"}
          g.reference_lines[:sys_high] = {value: 139, color: "#ba3a02"}
          g.reference_lines[:dia_normal] = {value: 79, color: "#a6ce39"}
          g.reference_lines[:dia_high] = {value: 89, color: "#ba3a02"}

          g.data("SYS", systolic_chart_data)
          g.data("DIA", diastolic_chart_data)
          g.minimum_value = 70
          g.maximum_value = 140
          g.y_axis_increment = 10
          g.label_rotation = 45

          g.legend_position = :bottom_right

          g.labels = dates_chart_data
          StringIO.new(g.to_image.to_blob)
        end

        def weight_chart_image
          g = Gruff::Line.new
          g.theme = theme
          g.title = "Gewicht"
          g.marker_font_size = 12

          g.data("Gewicht", weights)
          g.minimum_value = weights.compact.min - 1
          g.maximum_value = weights.compact.max + 1
          g.y_axis_increment = 0.5
          g.label_rotation = 45

          g.legend_position = :bottom_right

          g.labels = dates_chart_data
          StringIO.new(g.to_image.to_blob)
        end

        def theme
          @theme ||= {
            colors: [
              "#2066a8", # dark blue
              "#8cc5e3" # light blue
            ],
            marker_color: "#aea9a9", # Grey
            font_color: "black",
            background_colors: "white"
          }.freeze
        end
      end
    end
  end
end
