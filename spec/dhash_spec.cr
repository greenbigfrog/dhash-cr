require "./spec_helper"

# describe Dhash do
#   high = Vips::Image.new_from_file("spec/images/face-high.jpg")
#   low = Vips::Image.new_from_file("spec/images/face-low.jpg")
#   nose = Vips::Image.new_from_file("spec/images/face-with-nose.jpg")

#   it "should have similar hashes for low/high of same image" do
#     hash1 = Dhash.calculate(high)
#     hash2 = Dhash.calculate(low)

#     hamming(hash1, hash2).should be < 3
#   end

#   it "should have similar hashes for similar images" do
#     hash1 = Dhash.calculate(high)
#     hash2 = Dhash.calculate(nose)

#     hamming(hash1, hash2).should be < 5
#   end

#   it "should have identical hashes for identical images" do
#     hash1 = Dhash.calculate(high)
#     hash2 = Dhash.calculate(high)

#     hamming(hash1, hash2).should eq(0)
#   end
# end
