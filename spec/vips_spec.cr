high = "spec/images/face-high.jpg"

it "reads and writes back the same file" do
  img = Vips::Image.new_from_file("test")
  puts "Read img with width #{img.width} and height #{img.height}"
  img.write_to_file("out.jpg")
end

it "same file should equal itself" do
  i1 = Vips::Image.new_from_file(high)
  i2 = Vips::Image.new_from_file(high)

  i1.header.should be i2.header
end

it "resizes correctly" do
  # TODO
end

it "creates correctly" do
  # TODO
end

it "crops correctly" do
  # TODO
end
