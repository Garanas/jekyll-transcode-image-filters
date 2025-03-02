require_relative "lib/jekyll-transcode-image-filters/version"

Gem::Specification.new do |spec|
  spec.name        = 'jekyll-transcode-image-filters'
  spec.version     = Jekyll::TranscodeImageFilters::VERSION
  spec.date        = '2024-12-31'
  spec.summary     = 'Adds liquid filters to create responsive images and transcode them to browser-friendly formatspec.'
  spec.description = 'Adds the liquid filters `jpg` and `webp` to create responsive images and transcode them to browser-friendly formatspec. An optional parameter is available to also resize the image, as an example: `{{ imagePath | webp: "480x270" }}`'
  spec.authors     = ['Willem \'Jip\' Wijnia']
  spec.files       = Dir["lib/**/*"]
  spec.homepage    = 'https://github.com/Garanas/jekyll-transcode-image-filters'
  spec.license     = 'MIT'

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency 'jekyll', '> 3.3', '< 5.0'
  spec.add_dependency 'mini_magick', '~> 4.8'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.12.0"
  spec.add_development_dependency "typhoeus", ">= 0.7", "< 2.0"
end
