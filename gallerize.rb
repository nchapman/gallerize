require 'erb'
require 'rubygems'
require 'rmagick'

def read(path, file)
  File.open(File.join(path, file)) { |f| f.read }
end

def write(path, file, text)
  File.open(File.join(path, file), "w") { |f| f.write(text) }
end

def thumb(image, size)
  thumb_file_path = File.join(@output_path, "thumbs", File.basename(image, ".jpg") << "_#{size}.jpg")
  
  unless File.exists?(thumb_file_path)
    file = Magick::Image::read(image).first
    file.resize_to_fit!(size, size)
    file.write(thumb_file_path){ self.quality = size <= 250 ? 80 : 95 }
  end
  
  return File.basename(thumb_file_path)
end

def render(input_path, input_file, output_path, output_file, binding)
  write(output_path, output_file, ERB.new(read(input_path, input_file)).result(binding))
end

# Setup variables
@title = ARGV[0]
@output_path = File.join(ARGV[1], @title.downcase.gsub(/[^a-z0-9]/, ""))
@template_path = File.dirname(__FILE__)

# Create output paths
`mkdir -p "#{@output_path}"`
`mkdir -p "#{File.join(@output_path, "thumbs")}"`

# Gather images
@images = Dir["*.jpg"]

# Create Index file
render(@template_path, "index.html.erb", @output_path, "index.html", binding)

