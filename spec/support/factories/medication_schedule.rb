Factory.define(:medication_schedule) do |f|
  f.association(:user)
  f.association(:medication)
  f.morning 30
  f.noon 0
  f.evening 0
  f.before_bed 0
end
