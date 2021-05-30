class Vips::Image
  alias Af64 = Array(Float64) | Float64

  def self.new_from_file(path : String) : Vips::Image
    Vips::Image.new_from_file_rw(path)
  end

  # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#new_from_array-class_method
  # Create a new Image from a 1D or 2D array.
  # A 1D array becomes an image with height 1.
  # Use scale and offset to set the scale and offset fields in the header.
  # These are useful for integer convolutions.
  def self.new_from_array(array, scale = 1, offset = 0) : Vips::Image
    pp array
    return Vips::Image.new
    if array[0].is_a?(Array)
      height = array.size
      width = array[0].size

      raise "Not a 2D array" unless array.all? { |x| x.is_a?(Array) }
      raise "Array not rectangular" unless array.all? { |x| x.size == width }

      array = array.flatten
    else
      height = 1
      width = array.size
    end

    raise "Bad array dimensions." unless array.size == width * height
    raise "Not all array elements are Numeric" unless array.all? { |x| x.is_a? Number }

    image = Vips::Image.matrix_from_array(width, height, array)
    raise "Resulted in empty image" if image.nil?

    image.mutate do |mutable|
      # be careful to set them as double
      mutable.set_type! GObject::GDOUBLE_TYPE, "scale", scale.to_f
      mutable.set_type! GObject::GDOUBLE_TYPE, "offset", offset.to_f
    end
  end

  def write_to_file(filename : String)
    LibVips.vips_image_write_to_file(self, filename)
  end

  def resize(hscale : Float64, vscale : Float64)
    LibVips.vips_resize(self, out scaled, hscale, vscale)
    Vips::Image.new(scaled)
  end

  def crop(left, top, width, height)
    LibVips.vips_crop(self, out cropped, left, top, width, height)
    Vips::Image.new(cropped)
  end

  # https://www.rubydoc.info/gems/ruby-vips/Vips/Image#to_enum-instance_method
  def to_enum
    case self.format
    when Vips::BandFormat::UCHAR
      ptr = self.image_write_to_memory
      puts "Trying to read Char array from #{ptr}"
      array = Pointer(Array(Char)).new(ptr[1]).value
      pixel_array = array.each_slice(bands)
      pixel_array.each_slice width
    else
      raise "unsupported format"
    end
  end

  def to_a
    self.to_enum.to_a
  end

  def >(other)
    if other.is_a?(Vips::Image)
      other_image = other
    else
      other_image = Vips::Image.new_from_array([other])
    end

    LibVips.vips_relational(self, other_image, out compared, Vips::OperationRelational::MORE)
    Vips::Image.new(compared)
  end

  def linear(a_i : Af64, b_i : Af64)
    a = a_i.is_a?(Array(Float64)) ? a_i : [a_i]
    b = b_i.is_a?(Array(Float64)) ? b_i : [b_i]
    LibVips.vips_linear(self, out calculated, a, b, [a.size, b.size].max)
    Vips::Image.new(calculated)
  end

  def /(other)
    if other.is_a?(Vips::Image)
      divide(other)
    else
      linear(Image.smap(other) { |x| 1_f64 / x }, 0_f64)
    end
  end

  def divide(other)
    LibVips.divide(self, other, out result)
    Vips::Image.new(result)
  end

  def vips_cast(format)
    LibVips.vips_cast(self, out casted, format)
    Vips::Image.new(casted)
  end

  def vips_conv(mask)
    LibVips.vips_conv(self, out convulted, mask)
    Vips::Image.new(convulted)
  end

  def self.smap(x, &block : Int32 -> (Array(Float64) | Float64))
    x.is_a?(Array) ? x.map { |y| smap(y, &block) } : block.call(x)
  end
end