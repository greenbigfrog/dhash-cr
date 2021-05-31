require "spec"
require "../src/idhash"

describe "array" do
  it "calculates special median correctly" do
    [1, 2, 2, 2, 2, 2, 3].special_median.should eq(2)
    # fail unless 3 == @@median[[1, 2, 2, 2, 2, 3, 3]]
    [1, 2, 2, 2, 2, 3, 3].special_median.should eq(3)
    # fail unless 3 == @@median[[1, 1, 2, 2, 3, 3, 3]]
    [1, 1, 2, 2, 3, 3, 3].special_median.should eq(3)
    # fail unless 2 == @@median[[1, 1, 1, 2, 3, 3, 3]]
    [1, 1, 1, 2, 3, 3, 3].special_median.should eq(2)
    # fail unless 2 == @@median[[1, 1, 2, 2, 2, 2, 3]]
    [1, 1, 2, 2, 2, 2, 3].special_median.should eq(2)
    # fail unless 2 == @@median[[1, 2, 2, 2, 2, 3]]
    [1, 2, 2, 2, 2, 3].special_median.should eq(2)
    # fail unless 3 == @@median[[1, 2, 2, 3, 3, 3]]
    [1, 2, 2, 3, 3, 3].special_median.should eq(3)
    # fail unless 1 == @@median[[1, 1, 1]]
    [1, 1, 1].special_median.should eq(1)
    # fail unless 1 == @@median[[1, 1]]
    [1, 1].special_median.should eq(1)
  end

  it "calculates median correctly" do
    [1, 2, 2].median.should eq(2)
    [1, 2, 3, 4, 5].median.should eq(3)
    [1, 2, 3, 4, 5].shuffle.median.should eq(3)
  end
end
