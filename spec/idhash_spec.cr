require "spec"
require "../src/dhash"

describe "idhash" do
  it "calculates distance correctly" do
    a = BigInt.new("27362028616592833077810614538336061650596602259623245623188871925927275101952")
    b = BigInt.new("57097733966917585112089915289446881218887831888508524872740133297073405558528")
    IDHash.distance(a, b).should eq(76)

    a = BigInt.new("3c7e5c00664687ff1f7fc0007e7f3d000000120e808618ffc08007e0ff7f7f00", 16)
    b = BigInt.new("7e3c2c14343c7e7c487f7f227f7f00000042020440047e7e000080ff7fffff00", 16)
    IDHash.distance(a, b).should eq(76)
  end

  it "calculates hash correctly" do
    high = Vips::Image.new_from_file("spec/images/face-high.jpg")
    IDHash.fingerprint(high).should eq("TBD")
  end
end
