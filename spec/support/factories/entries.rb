Factory.define(:entry) do |f|
  f.date { Date.today }
  f.attention { (0..5).to_a.sample }
  f.organisation { (0..5).to_a.sample }
  f.mood_swings { (0..5).to_a.sample }
  f.stress_sensitivity { (0..5).to_a.sample }
  f.irritability { (0..5).to_a.sample }
  f.restlessness { (0..5).to_a.sample }
  f.impulsivity { (0..5).to_a.sample }
  f.side_effects ""
  f.blood_pressure "126/74"
  f.weight 126.7
  f.association(:user)
end
