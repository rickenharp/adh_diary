require "rom-factory"

Factory = ROM::Factory.configure do |config|
  config.rom = Hanami.app["db.rom"]
end
