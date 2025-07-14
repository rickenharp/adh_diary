# frozen_string_literal: true

require "capybara/rspec"
require "capybara/cuprite"

Capybara.default_max_wait_time = 20
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], timeout: 20, process_timeout: Capybara.default_max_wait_time)
end
Capybara.javascript_driver = :cuprite

Capybara.app = Hanami.app

# Capybara.default_max_wait_time = 5
# Capybara.disable_animation = true
#
# RSpec.configure do |config|
#   config.before(:each, type: :system) do
#     driven_by(:cuprite, screen_size: [1440, 810], options: {
#       js_errors: true,
#       headless: %w[0 false].exclude?(ENV["HEADLESS"]),
#       slowmo: ENV["SLOWMO"]&.to_f,
#       process_timeout: 15,
#       timeout: 10,
#       browser_options: ENV["DOCKER"] ? {"no-sandbox" => nil} : {}
#     })
#   end
#
#   config.filter_gems_from_backtrace("capybara", "cuprite", "ferrum")
# end
