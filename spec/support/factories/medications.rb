Factory.define(:medication) do |f|
  f.name { fake(:cannabis, :strain) }
end
