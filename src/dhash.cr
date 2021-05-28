require "crymagick"
require "big/big_int"

# https://github.com/maccman/dhash/blob/master/lib/dhash.rb

module Dhash
  VERSION = "0.1.0"

  Rec601LumaColorspace = "Rec601YCbCr"

  def self.hamming(a, b)
    # hash1 = a.to_s.to_slice
    # hash2 = b.to_s.to_slice

    # count = 0
    # hash1.each_with_index do |x, i|
    #   count += (x ^ hash2[i]).popcount
    # end
    # count
    (a ^ b).popcount
  end

  def self.calculate(file : File, hash_size : Int32 = 8)
    #     image = Magick::Image.read(file).first
    raw_image = CryMagick::Image.read(file)

    #     image = image.quantize(256, Magick::Rec601LumaColorspace, Magick::NoDitherMethod, 8)
    image = raw_image.combine_options do |b|
      b.quantize(Rec601LumaColorspace)
      b.colorspace(Rec601LumaColorspace)
      b.colors(256)
      b.dither.+
      b.treedepth(8)
    end

    image.write("test.png")

    #     image = image.resize!(hash_size + 1, hash_size)
    img = image.resize("#{hash_size+1}x#{hash_size}")

    img.write("resized.png")

    #     difference = []
    difference = Array(Bool).new

    img_pixels = img.get_pixels

    #     hash_size.times do |row|
    puts "size: #{hash_size}"
    hash_size.times do |row|
      #       hash_size.times do |col|
      hash_size.times do |col|
        #         pixel_left  = image.pixel_color(col, row).intensity
        pixel_left = pixel_intensity(img_pixels[col][row])
        #         pixel_right = image.pixel_color(col + 1, row).intensity
        pixel_right = nil
        if next_col = img_pixels[col+1]?
          pixel_right = pixel_intensity(next_col[row])
        end

        #         difference << (pixel_left > pixel_right)
        if pixel_right
          difference << (pixel_left > pixel_right)
        else
          difference << true
        end
      end
    end

    #     difference.map {|d| d ? 1 : 0 }.join('').to_i(2)
    a = difference.map {|d| d ? 1 : 0 }.join("")
    BigInt.new(a, 2)
  end

  def self.pixel_intensity(pixel : CryMagick::Image::Pixel) : Int32
    # https://github.com/rmagick/rmagick/blob/d64a08b378fd1f713cbe11696f8b1edc6929da6b/ext/RMagick/rmpixel.c#L970
    a = 0.299*pixel[0] + 0.587*pixel[1] + 0.114*pixel[2]
    a.to_i32
  end
end
