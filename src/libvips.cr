lib LibVips
  alias Img = LibVips::Image

  # https://libvips.github.io/libvips/API/current/libvips-resample.html#vips-resize
  # rb: vips_resize(in, out, scale, "vscale", vscale, "kernel", kernel, NULL);
  # fun vips_resize(input : Img*, output : Img**, hscale : LibC::Double, vscale : LibC::Double, ...)

  # https://libvips.github.io/libvips/API/current/VipsImage.html#vips-image-write-to-file
  # fun vips_image_write_to_file(image : LibVips::Image*, name : LibC::Char*)

  # https://libvips.github.io/libvips/API/current/libvips-conversion.html#vips-cast
  # fun vips_cast(input : Img*, output : Img**, band : Int32)

  # https://libvips.github.io/libvips/API/current/libvips-convolution.html#vips-conv
  # fun vips_conv(input : Img*, output : Img**, mask : Img*)

  # https://libvips.github.io/libvips/API/current/libvips-conversion.html#vips-crop
  # fun vips_crop(input : Img*, output : Img**, left : Int32, top : Int32, width : Int32, height : Int32)

  # https://libvips.github.io/libvips/API/current/libvips-arithmetic.html#vips-relational
  # fun vips_relational(left : Img*, right : Img*, output : Img**, operation : LibVips::OperationRelational)

  # https://libvips.github.io/libvips/API/current/libvips-arithmetic.html#vips-linear
  # Pass an image through a linear transform, ie. (out = input * a + b ).
  # fun vips_linear(input : Img*, output : Img**, a : LibC::Double*, b : LibC::Double*, n : Int32, ...)

  # https://libvips.github.io/libvips/API/current/libvips-arithmetic.html#vips-divide
  # fun vips_divide(left : Img*, right : Img*, output : Img**, ...)

  # https://libvips.github.io/libvips/API/current/VipsImage.html#vips-image-new-from-buffer
  # fun vips_image_new_from_buffer(buf : Void*, len : LibC::SizeT, char : LibC::Char*, ...) : LibVips::Image*
  # TODO make sure we don't have to unref or something above
  # See https://github.com/libvips/libvips/issues/1544 for easy to follow guide

  # https://libvips.github.io/libvips/API/current/VipsForeignSave.html#vips-pngload-buffer
  # returns 0 on success, -1 on error (or more specific, raises it)
  fun vips_pngload_buffer(buf : Void*, len : LibC::SizeT, output : LibVips::Image**, ...) : LibC::Int
end
