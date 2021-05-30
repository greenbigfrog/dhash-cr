require "gobject"
require_gobject "Vips"

require "./*"

module Dhash
  extend self

  def pixelate(img, hash_size) : Vips::Image
    hscale = (hash_size + 1).fdiv(img.width)
    vscale = hash_size.fdiv(img.height)
    img.resize(hscale, vscale)
  end

  def calculate(img, hash_size : Int32 = 8)
    pixelated = pixelate(img, hash_size)
    puts "image resized/pixelated"

    # image.cast("int")
    # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#cast-instance_method
    formatted = pixelated.vips_cast(Vips::BandFormat::INT)
    puts "we formatted image"

    # .conv([[1, -1]])
    # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#conv-instance_method
    # Each output pixel is calculated as sigma[i]{pixel[i] * mask[i]} / scale + offset,
    # where scale and offset are part of mask.
    mask = Vips::Image.new_from_array([[1, -1]])
    reduced = formatted.vips_conv(mask)
    puts "we applied mask"

    # .crop(1, 0, hash_size, hash_size)
    # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#crop-instance_method
    cropped = reduced.crop(1, 0, hash_size, hash_size)
    puts "we cropped"

    # .>(0)
    # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#%3E-instance_method
    more = cropped.>(0)
    puts "we compared"

    # ./(255)
    # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#%2F-instance_method
    divided = more./(255)
    puts "we divided"

    # .cast("uchar")
    ucharred = divided.vips_cast(Vips::BandFormat::UCHAR)
    puts "we converted to uchars"

    # .to_a
    array = ucharred.to_a

    # .join.to_i(2)
    output = array.join.to_i(2)
    puts "we're done"

    output
  end
end

puts "Reading image"
img = Vips::Image.new_from_file("spec/images/face-high.jpg")
puts "Read img with width #{img.width} and height #{img.height}"

# a = img.resize(10, 0.1)
# puts "Resized img to width #{a.width} and height #{a.height}"

Dhash.calculate(img)
