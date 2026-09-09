Factory.define(:weight) do |f|
  f.weight 123.45
  f.date { Date.today }
  f.association(:account)
end
