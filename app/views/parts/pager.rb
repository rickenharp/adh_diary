# auto_register: false
# frozen_string_literal: true

module AdhDiary
  module Views
    module Parts
      class Pager < AdhDiary::Views::Part
        NUMBER_OF_MIDDLE_LINKS = 3
        def visible_pages
          all_pages = (1..total_pages).to_a

          index = current_page - 1
          clamp_max = all_pages.size - NUMBER_OF_MIDDLE_LINKS
          center = (index - (NUMBER_OF_MIDDLE_LINKS / 2))

          return all_pages if clamp_max < NUMBER_OF_MIDDLE_LINKS
          slice = all_pages.slice(center.clamp(0, clamp_max), NUMBER_OF_MIDDLE_LINKS)

          prepend = if slice.include?(1)
            []
          else
            [1, nil]
          end

          append = if slice.include?(total_pages)
            []
          elsif slice.include?(total_pages - 1)
            [total_pages]
          else
            [nil, total_pages]
          end

          prepend + slice + append
        end
      end
    end
  end
end
