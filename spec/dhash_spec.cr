require "./spec_helper"

describe Dhash do
  it "should have similar hashes for low/high of same image" do
    hash1 = Dhash.calculate(File.open("/home/frog/dhash-cr/spec/images/face-high.jpg"))
    hash2 = Dhash.calculate(File.open("/home/frog/dhash-cr/spec/images/face-low.jpg"))

    Dhash.hamming(hash1, hash2).should be < 3
  end

  it "should have similar hashes for similar images" do
    hash1 = Dhash.calculate(File.open("/home/frog/dhash-cr/spec/images/face-high.jpg"))
    hash2 = Dhash.calculate(File.open("/home/frog/dhash-cr/spec/images/face-with-nose.jpg"))

    Dhash.hamming(hash1, hash2).should be < 5
  end

  it "should have identical hashes for identical images" do
    hash1 = Dhash.calculate(File.open("/home/frog/dhash-cr/spec/images/face-high.jpg"))
    hash2 = Dhash.calculate(File.open("/home/frog/dhash-cr/spec/images/face-high.jpg"))

    Dhash.hamming(hash1, hash2).should eq(0)
  end
end
