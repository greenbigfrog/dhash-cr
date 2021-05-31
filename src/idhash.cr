require "big/big_int"


class Array(T)
  # Returns special median element or nil
  def special_median : T?
    h = (@size / 2).to_i32
    return @buffer[h] if @buffer[h] != @buffer[h-1]
    right = dup
    left = right.shift h
    right.shift if right.size > left.size
    return right.first if left.last != right.first
    return right.uniq[1] if left.count(left.last) > right.count(right.first)
    left.last
  end

  # Returns median element or nil
  def median : T?
    return nil if @size == 0
    sorted = dup.sort!
    i = @size / 2
    sorted[i.to_i32]
  end
end

module IDHash
  extend self

  def distance(a, b)
    (a^b).popcount
  end

  def fingerprint(img, power = 3)
    # size = 2 ** power
    size = 2 ** power

    #   image = Vips::Image.new_from_file filename, access: :sequential
    # obsolete

    #   image = image.resize(size.fdiv(image.width), vscale: size.fdiv(image.height))
    hscale = size.fdiv(img.width)
    vscale = size.fdiv(img.height)
    image = img.resize(hscale, vscale)
    #       .colourspace("b-w")
    bw = image.colourspace(Vips::Interpretation::B_W)
    #       .flatten
    flat = bw.flatten

    #   array = image.to_a.map &:flatten
    array = flat.to_a.map {|x| x.flatten }
    #   d1, i1, d2, i2 = [array, array.transpose].flat_map do |a|
    #     d = a.zip(a.rotate(1)).flat_map{ |r1, r2| r1.zip(r2).map{ |i,j| i - j } }
    #     m = @@median.call d.map(&:abs).sort
    #     [
    #       d.map{ |c| c     <  0 ? 1 : 0 }.join.to_i(2),
    #       d.map{ |c| c.abs >= m ? 1 : 0 }.join.to_i(2),
    #     ]
    #   end
    #   (((((i1 << size * size) + i2) << size * size) + d1) << size * size) + d2
  end
end
