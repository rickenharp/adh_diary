# frozen_string_literal: true

RSpec.describe AdhDiary::WithingsMapper do
  let(:json) do
    '{"status":0,"body":{"updatetime":1753007886,"timezone":"Europe\/Berlin","measuregrps":[{"grpid":6721929023,"attrib":0,"date":1753007880,"created":1753007886,"modified":1753007886,"category":1,"deviceid":"f875d0f88f2b39c535bf06fe3d09c1ec21c5590a","hash_deviceid":"f875d0f88f2b39c535bf06fe3d09c1ec21c5590a","measures":[{"value":77000,"type":9,"unit":-3,"algo":0,"fm":3},{"value":118000,"type":10,"unit":-3,"algo":0,"fm":3}],"modelid":42,"model":"Withings Blood Pressure Monitor V2","comment":null},{"grpid":6721025574,"attrib":0,"date":1752988427,"created":1752988484,"modified":1752988484,"category":1,"deviceid":"11cb37ed8b6b312ca57289180d9c5c2430198627","hash_deviceid":"11cb37ed8b6b312ca57289180d9c5c2430198627","measures":[{"value":122859,"type":1,"unit":-3,"algo":3,"fm":3}],"modelid":6,"model":"Body Cardio","comment":null}]}}'
  end

  it "works" do
    data = JSON.parse(json)
    wanted = {
      blood_pressure: "118/77",
      weight: 122.86
    }

    expect(subject.call(data)).to eq(wanted)
  end
end
