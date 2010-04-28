require 'erb'
require 'fileutils'
require 'rubygems'
require 'rmagick'
require 'natural_sort_kernel'

class Gallerizer
  include FileUtils
  
  def initialize(name, output_path, theme)
    @name = name
    @output_path = output_path
    @theme_path = File.join(File.dirname(__FILE__), "..", "themes", theme)
  end

  def resize(image, size, square = false)
    thumb_file_path = File.join(@output_path, "thumbs", File.basename(image, ".jpg") << "_#{size}.jpg")
  
    unless File.exists?(thumb_file_path)
      file = Magick::Image::read(image).first
    
      if square
        file.resize_to_fill!(size, size)
      else
        file.resize_to_fit!(size, size)
      end

      file.write(thumb_file_path){ self.quality = (size <= 250 ? 70 : 95) }
    end
  
    File.basename(thumb_file_path)
  end

  def next_image(i)
    @images.size - 1 != i ? @images[i + 1] : nil
  end

  def previous_image(i)
    i != 0 ? @images[i - 1] : nil
  end
  
  def generate
    # Create necessary output paths
    mkdir_p([@output_path, File.join(@output_path, "thumbs"), File.join(@output_path, "show"), File.join(@output_path, "resources")])

    # Copy resource files
    cp_r(File.join(@theme_path, "resources/."), File.join(@output_path, "resources"))

    # Gather images
    @images = Dir["*.jpg"].natural_sort

    # Load templates
    index_template = ERB.new(File.open(File.join(@theme_path, "index.html.erb")) { |f| f.read })
    show_template = ERB.new(File.open(File.join(@theme_path, "show.html.erb")) { |f| f.read })

    # Create index page
    File.open(File.join(@output_path, "index.html"), "w") { |f| f.write(index_template.result(binding)) }

    # Create show pages
    @images.each_with_index do |image, i|
      File.open(File.join(@output_path, "show", "#{i}.html"), "w") { |f| f.write(show_template.result(binding)) }
    end
  end
end