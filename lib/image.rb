class Image
  attr_reader :id, :path
  
  def initialize(id, path, output_path)
    @id = id
    @path = path
    @output_path = output_path
  end
  
  def basename
    File.basename(@path)
  end
  
  def resize(size, square = false)
    thumb_file_path = File.join(@output_path, "thumbs", File.basename(@path, ".jpg") << "_#{size}.jpg")
  
    unless File.exists?(thumb_file_path)
      file = Magick::Image::read(@path).first
    
      if square
        file.resize_to_fill!(size, size)
      else
        file.resize_to_fit!(size, size)
      end

      file.write(thumb_file_path)
      
      # Free memory
      file.destroy!
    end
  
    File.join("thumbs", File.basename(thumb_file_path))
  end
  
  def to_s
    basename
  end
end