require "./spec_helper"

describe Vips::Image do
  it "reads image from IO" do
    i = File.read("spec/img/2.png")
    Img.new(IO::Memory.new(i))
  end
end
