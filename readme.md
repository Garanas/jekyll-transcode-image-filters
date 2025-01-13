# Responsive and browser-friendly images

This gem provides filters for [Jekyll](https://jekyllrb.com/) that make it easy to work with responsive and browser-friendly images. Through filters a developer has more control over the HTML that is generated.

## Features

- `jpg` filter: Transcodes an image to the [JPG](https://en.wikipedia.org/wiki/JPEG) format.
- `webp` filter: Transcodes an image to the [WebP](https://en.wikipedia.org/wiki/WebP) format.
- `avif` filter: Transcodes an image to the [AVIF](https://en.wikipedia.org/wiki/AVIF) format.
  
Both filters support an optional parameter for resizing images. For example:

```liquid
{{ imagePath | webp: "480x270" }}
```

### Use case: compressing images

These filters enable you to automatically convert any common image format into the best browser-friendly format that the browser of a user supports. This can significantly reduce the bandwidth that may be necessary to load the image. 

```liquid
{% assign imagePath = "assets/images/some-image.bmp" %}

<picture>
  <source srcset="{{ imagePath | avif | relative_url }}" type="image/avif">
  <source srcset="{{ imagePath | webp | relative_url }}" type="image/webp">
  <source srcset="{{ imagePath | jpg | relative_url }}" type="image/jpeg">

  <img class="image" src="{{ imagePath | relative_url }}" alt="{{include.alt}}">
</picture>
```

This is converted by Jekyll into:

```liquid
<picture>
  <source srcset="/cache/avif/4271c8a52c6e4271ae912271f5e43f20.avif" type="image/avif">
  <source srcset="/cache/webp/4271c8a52c6e4271ae912271f5e43f20.webp" type="image/webp">
  <source srcset="/cache/jpg/4271c8a52c6e4271ae912271f5e43f20.jpg" type="image/jpeg">

  <img class="thumbnail-image" src="/assets/thumbnails-wide/tournament-cybran-01-2024.png" alt="Some alternative text about the image">
</picture>
```

### Use case: responsive images

These filters enable declarative creation of responsive images. Here's an example [include](https://jekyllrb.com/docs/includes/) template for a responsive thumbnail:

```liquid
{% assign assetsFolder = 'assets/images/' %}

<picture>
  {% assign imagePath = assetsFolder | append: include.url %}
  
  <source media="(max-width: 960px)" srcset="{{ imagePath | avif: "240x135" | relative_url }}" type="image/avif">
  <source media="(max-width: 1920px)" srcset="{{ imagePath | avif: "480x270" | relative_url }}" type="image/avif">
  <source media="(max-width: 2560px)" srcset="{{ imagePath | avif: "960x540" | relative_url}}" type="image/avif">


  <source media="(max-width: 960px)" srcset="{{ imagePath | webp: "240x135" | relative_url }}" type="image/webp">
  <source media="(max-width: 1920px)" srcset="{{ imagePath | webp: "480x270" | relative_url }}" type="image/webp">
  <source media="(max-width: 2560px)" srcset="{{ imagePath | webp: "960x540" | relative_url}}" type="image/webp">

  <source media="(max-width: 960px)" srcset="{{ imagePath | jpg: "240x135" | relative_url }}" type="image/jpeg">
  <source media="(max-width: 1920px)" srcset="{{ imagePath | jpg: "480x270" | relative_url }}" type="image/jpeg">
  <source media="(max-width: 2560px)" srcset="{{ imagePath | jpg: "960x540" | relative_url }}" type="image/jpeg">

  <img class="thumbnail-image" src="{{ imagePath | relative_url }}" alt="{{include.alt}}">
</picture>
```

This is converted by Jekyll into:

```html
<picture>
  <source media="(max-width: 960px)" srcset="cache/avif/4271c8a52c6e4271ae912271f5e43f20-240x135.avif" type="image/avif">
  <source media="(max-width: 1920px)" srcset="cache/avif/4271c8a52c6e4271ae912271f5e43f20-480x270.avif" type="image/avif">
  <source media="(max-width: 2560px)" srcset="cache/avif/4271c8a52c6e4271ae912271f5e43f20-960x540.avif" type="image/avif">

  <source media="(max-width: 960px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-240x135.webp" type="image/webp">
  <source media="(max-width: 1920px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-480x270.webp" type="image/webp">
  <source media="(max-width: 2560px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-960x540.webp" type="image/webp">

  <source media="(max-width: 960px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-240x135.webp" type="image/jpeg">
  <source media="(max-width: 1920px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-480x270.webp" type="image/jpeg">
  <source media="(max-width: 2560px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-960x540.webp" type="image/jpeg">

  <img class="thumbnail-image" src="/assets/thumbnails-wide/tournament-cybran-01-2024.png" alt="Some alternative text about the image">
</picture>
```

## Installation

Add the gem to your Jekyll site's Gemfile under the jekyll_plugins group:

```ruby
# If you have any plugins, put them here!
group :jekyll_plugins do

    # (...)

    gem 'jekyll-transcode-image-filters', git: "https://github.com/Garanas/jekyll-transcode-image-filters"
end
```

Then, run in the command line:

```
bundle install
```

### Compatibility note

:warning: If you are using Jekyll < 3.5.0 use the `gems` key instead of `plugins`.

## References

- [Responsive images](https://developer.mozilla.org/en-US/docs/Web/HTML/Responsive_images)
- [Image file type and format guide](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Image_types)
- [Optimize Cumulative Layout Shift](https://web.dev/articles/optimize-cls)
- [WebP compression study](https://developers.google.com/speed/webp/docs/webp_study)
- [Comprehensive Image Quality Assessment (IQA) of JPEG, WebP, HEIF and AVIF Formats](https://osf.io/preprints/osf/ud7w4)

### Guides

- [Your first Jekyll plugin](https://perseus333.github.io/blog/jekyll-first-plugin)

### Similar plugins

- [Jekyll Assets](https://github.com/envygeeks/jekyll-assets)
- [Jekyll Resize](https://github.com/MichaelCurrin/jekyll-resize)
