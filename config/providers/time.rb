Hanami.app.register_provider(:time) do
  start do
    register :time, -> { Time.now }
  end
end
