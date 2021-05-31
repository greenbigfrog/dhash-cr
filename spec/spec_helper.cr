require "spec"
require "../src/dhash"

def high
  high = Vips::Image.new_from_file("spec/images/face-high.jpg")
end

def low
  Vips::Image.new_from_file("spec/images/face-low.jpg")
end

def nose
  Vips::Image.new_from_file("spec/images/face-with-nose.jpg")
end
