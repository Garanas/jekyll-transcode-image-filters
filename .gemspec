require_relative "lib/jekyll-transcode-image-filters/version"

Gem::Specification.new do |s|
  s.name        = 'jekyll-transcode-image-filters'
  s.version     = Jekyll::TranscodeImageFilters::VERSION
  s.date        = '2024-12-31'
  s.summary     = 'Adds the liquid filters to create responsive images and transcode them to browser-friendly formats.'
  s.description = 'Adds the liquid filters `jpg` and `webp` to create responsive images and transcode them to browser-friendly formats. An optional parameter is available to also resize the image, as an example: `{{ imagePath | webp: "480x270" }}`'
  s.authors     = ['Willem \'Jip\' Wijnia']
  s.files       = Dir["lib/**/*"]
  s.homepage    = 'https://github.com/Garanas/jekyll-transcode-image-filters'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 3.0.0"

  s.add_dependency 'jekyll', '> 3.3', '< 5.0'
  s.add_dependency 'mini_magick', '~> 4.8'
end
