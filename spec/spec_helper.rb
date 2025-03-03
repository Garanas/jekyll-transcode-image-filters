# frozen_string_literal: true

require 'jekyll'
require 'mini_magick'
require File.expand_path('../lib/jekyll_transcode_image_filters', __dir__)

Jekyll.logger.log_level = :error

SOURCE_DIR = File.expand_path('fixture', __dir__)
DEST_DIR   = File.expand_path('dest',     __dir__)

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.before(:suite) do
    # Delete the cache directory
    FileUtils.rm_rf(File.join(SOURCE_DIR, 'cache'))
  end

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  def make_context(registers = {})
    Liquid::Context.new({}, {}, { site: site }.merge(registers))
  end

  def get_image_resolution(file_path)
    image = MiniMagick::Image.open(file_path)
    [image.width, image.height]
  end
end
