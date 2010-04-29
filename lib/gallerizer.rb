require 'erb'
require 'fileutils'
require 'rubygems'
require 'rmagick'
require 'natural_sort_kernel'
require File.join(File.dirname(__FILE__), 'image')

class Gallerizer
  include FileUtils
  
  def initialize(name, output_path, theme)
    @name = name
    @output_path = output_path
    @theme_path = File.join(File.dirname(__FILE__), "..", "themes", theme)
  end
  
  def gallerize
    # Create necessary output paths
    mkdir_p([@output_path, File.join(@output_path, "thumbs"), File.join(@output_path, "show"), File.join(@output_path, "resources")])

    # Copy resource files
    cp_r(File.join(@theme_path, "resources/."), File.join(@output_path, "resources"))

    # Gather images
    image_paths = Dir["*.jpg"].natural_sort
    @images = image_paths.collect { |image_path| Image.new(image_paths.index(image_path), File.expand_path(image_path), @output_path) }
    
    # Load templates
    index_template = ERB.new(File.open(File.join(@theme_path, "index.html.erb")) { |f| f.read })
    show_template = ERB.new(File.open(File.join(@theme_path, "show.html.erb")) { |f| f.read })

    # Create index page
    File.open(File.join(@output_path, "index.html"), "w") { |f| f.write(index_template.result(binding)) }

    # Create show pages
    @images.each do |image|
      previous_image = (image.id != 0 ? @images[image.id - 1] : nil)
      next_image = (@images.size - 1 != image.id ? @images[image.id + 1] : nil)
      
      File.open(File.join(@output_path, "show", "#{image.id}.html"), "w") { |f| f.write(show_template.result(binding)) }
    end
  end
end