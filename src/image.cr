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
    puts "Creating new from array"
    x = -1_f64
    y = 1_f64
    a = [x, y]
    return Vips::Image.matrix_from_array(2, 2, a)
    # if array[0].is_a?(Array)
    #   height = array.size
    #   width = array[0].size

    #   raise "Not a 2D array" unless array.all? { |x| x.is_a?(Array) }
    #   raise "Array not rectangular" unless array.all? { |x| x.size == width }

    #   array = array.flatten
    # else
    #   height = 1
    #   width = array.size
    # end

    # raise "Bad array dimensions." unless array.size == width * height
    # raise "Not all array elements are Numeric" unless array.all? { |x| x.is_a? Number }

    # image = Vips::Image.matrix_from_array(width, height, array)
    # raise "Resulted in empty image" if image.nil?

    # image.mutate do |mutable|
    #   # be careful to set them as double
    #   mutable.set_type! GObject::GDOUBLE_TYPE, "scale", scale.to_f
    #   mutable.set_type! GObject::GDOUBLE_TYPE, "offset", offset.to_f
    # end
  end

  def write_to_file(filename : String)
    LibVips.vips_image_write_to_file(self, filename)
  end

  def resize(scale : Float64, vscale : Float64? = nil)
    operation = Vips::Operation.new("resize")
    operation.set_property("in", in)
    operation.set_property("scale", scale)
    operation.set_property("vscale", vscale) if vscale
    run_and_get_output(operation)
  end

  def crop(left, top, width, height)
    op = Vips::Operation.new("crop")
    op.set_property("input", in)
    op.set_property("left", left)
    op.set_property("top", top)
    op.set_property("width", width)
    op.set_property("height", height)
    run_and_get_output(op)
  end

  def to_a
    to_enum.to_a
  end

  def to_enum
    case self.format
    when Vips::BandFormat::UCHAR
      ptr = self.image_write_to_memory
      glib_ptr = ptr[0]
      pixel_array = Array(UInt8).new
      i = 0
      glib_ptr.each do |x|
        i+=1
        break if i > 64

        pixel_array << x
      end

      raise "Issue Reading from memory" if pixel_array.nil?
      banded_array = pixel_array.each_slice(bands)
      raise "Issue unpacking" if banded_array.nil?
      banded_array.each_slice width
    else
      raise "unsupported format"
    end
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

    # TODO ArrayDouble fails to convert to GValue
    op = Vips::Operation.new("linear")
    op.set_property("in", in)
    op.set_property("a", Vips::ArrayDouble.new(a).to_gvalue)
    op.set_property("b", Vips::ArrayDouble.new(b).to_gvalue)
    run_and_get_output(op)
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
    op = Vips::Operation.new("cast")
    op.set_property("in", in)
    op.set_property("format", format)
    run_and_get_output(op)
  end

  def vips_conv(mask)
    op = Vips::Operation.new("conv")
    op.set_property("in", in)
    op.set_property("mask", mask.in)
    run_and_get_output(op)
  end

  def colourspace(space : Vips::Interpretation, sourcespace : Vips::Interpretation? = nil)
    op = Vips::Operation.new("colourspace")
    op.set_property("in", in)
    op.set_property("space", space)
    op.set_property("source-space", sourcespace) if sourcespace
    run_and_get_output(op)
  end

  def flatten(background : Vips::ArrayDouble? = nil, max_alpha : LibC::Double? = nil)
    op = Vips::Operation.new("flatten")
    op.set_property("in", in)
    op.set_property("background", background) if background
    op.set_property("max-alpha", max_alpha) if max_alpha
    run_and_get_output(op)
  end

  private def in
    GObject::Object.new(to_unsafe.as(LibGObject::Object*))
  end

  # for operations with output name "out"
  private def run_and_get_output(operation)
    Vips.cache_operation_build(operation)
    output = GObject::Value.new(type: LibVips._vips_image_get_type)
    LibGObject.object_get_property(operation.to_unsafe.as(LibGObject::Object*), "out", output)
    Vips::Image.new(output.object.to_unsafe.as(LibVips::Image*))
  end

  def self.smap(x, &block : Int32 -> (Array(Float64) | Float64))
    x.is_a?(Array) ? x.map { |y| smap(y, &block) } : block.call(x)
  end
end
