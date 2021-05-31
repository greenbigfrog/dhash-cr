require "spec"
require "./spec_helper"
require "../src/dhash"

describe "idhash" do
  it "should calculate hash correctly" do
    IDHash.fingerprint(high).to_s(16).should eq("7c7e63387b663c007e5e17407b7a3e0800003cc2ff7e7e1c001004407b633e18")
    IDHash.fingerprint(low).to_s(16).should eq("7c7ea3387b623e007e5617007b7a3e0800003cc2ff7e7e1c001004407f633e18")
    IDHash.fingerprint(nose).to_s(16).should eq("7c7e7b387b663c007e5e0f486b7a3e0800003cc2ff7e7e1c00100c407b633e18")
  end

  it "should have identical hash for identical file" do
    h1 = IDHash.fingerprint(high)
    h2 = IDHash.fingerprint(high)
    h1.should eq(h2)
  end

  it "should have similar hashes for low/high of same image" do
    h1 = IDHash.fingerprint(high)
    h2 = IDHash.fingerprint(low)
    IDHash.distance(h1, h2).should eq(0)
  end

  it "should have similar hashes for similar images" do
    h1 = IDHash.fingerprint(high)
    h2 = IDHash.fingerprint(nose)
    IDHash.distance(h1, h2).should eq(1)
  end
end
