require "./spec_helper"

def high
  high = File.read("spec/images/face-high.jpg")
end

describe Vips::Image do
  it "reads image from IO" do
    i = File.read("spec/img/2.png")
    Img.new(IO::Memory.new(i))
  end

  it "reads even more from IO" do
    o = IO::Memory.new(high)
    Vips::Image.new(o)
  end

  it "reads from string" do
    Vips::Image.new(high)
  end
end
