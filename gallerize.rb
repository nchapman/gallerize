require 'erb'
require 'rubygems'
require 'rmagick'
require 'natural_sort_kernel'

def read(path_parts)
  File.open(File.join(path_parts)) { |f| f.read }
end

def write(path_parts, text)
  File.open(File.join(path_parts), "w") { |f| f.write(text) }
end

def render(input_path_parts, output_path_parts, binding)
  write(output_path_parts, ERB.new(read(input_path_parts)).result(binding))
end

def resize(image, size, square = false)
  thumb_file_path = File.join(@output_path, "thumbs", File.basename(image, ".jpg") << "_#{size}.jpg")
  
  unless File.exists?(thumb_file_path)
    file = Magick::Image::read(image).first
    
    puts "Generating #{File.basename(thumb_file_path)}..."
    
    if square
      file.resize_to_fill!(size, size)
    else
      file.resize_to_fit!(size, size)
    end

    file.write(thumb_file_path){ self.quality = size <= 250 ? 80 : 95 }
  end
  
  return File.basename(thumb_file_path)
end

def next?(index)
  @images.size - 1 != index
end

def previous?(index)
  index != 0
end

# Setup variables
@title = ARGV[0]
@output_path = File.join(ARGV[1], @title.downcase.gsub(/[^a-z0-9]/, ""))
@template_path = File.dirname(__FILE__)

# Create output paths
`mkdir -p "#{@output_path}"`
`mkdir -p "#{File.join(@output_path, "thumbs")}"`
`mkdir -p "#{File.join(@output_path, "show")}"`

# Copy support files
`cp #{File.join(@template_path, "screen.css")} #{File.join(@output_path, "screen.css")}`

# Gather images
@images = Dir["*.jpg"].natural_sort

# Create Index page
render([@template_path, "index.html.erb"], [@output_path, "index.html"], binding)

# Create Image pages

@images.each_with_index do |image, i|
  render([@template_path, "show.html.erb"], [@output_path, "show", "#{i}.html"], binding)
end