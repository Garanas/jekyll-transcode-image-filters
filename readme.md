# Responsive and browser-friendly images

Introduces the following filters that can be used in Liquid:

- `jpg`: Transcodes an image to the JPG format
- `webp`: Transcodes an image to the WebP format

Both filters accept a conditional parameter that allows you to resize an image. As an example: `{{ imagePath | webp: "480x270" }}`. The resolution is interpret as `WIDTHxHEIGHT`. Through these filters you can create [responsive images](https://developer.mozilla.org/en-US/docs/Web/HTML/Responsive_images) declaratively. As an example, you could create the following [include](https://jekyllrb.com/docs/includes/) for a thumbnail:

```liquid
{% assign assetsFolder = 'assets/thumbnails-wide/' %}

<picture>
  {% assign imagePath = assetsFolder | append: include.url %}
  
  <source
    media="(max-width: 960px)"
    srcset="{{ imagePath | webp: "240x135" }}"
    type="image/webp"
  >
  <source
    media="(max-width: 1920px)"
    srcset="{{ imagePath | webp: "480x270" }}"
    type="image/webp"
  >
  <source
    media="(max-width: 2560px)"
    srcset="{{ imagePath | webp: "960x540"}}"
    type="image/webp"
  >

  <source
    media="(max-width: 960px)"
    srcset="{{ imagePath | jpg: "240x135" }}"
    type="image/jpeg"
  >
  <source
    media="(max-width: 1920px)"
    srcset="{{ imagePath | jpg: "480x270" }}"
    type="image/jpeg"
  >
  <source
    media="(max-width: 2560px)"
    srcset="{{ imagePath | jpg: "960x540" }}"
    type="image/jpeg"
  >

  <img class="thumbnail-image" src="{{ imagePath | relative_url }}" alt="{{include.alt}}">
</picture>
```

Which is turned into the following HTML by Jekyll:

```html
<picture>
  <source media="(max-width: 960px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-240x135.webp" type="image/webp">
  <source media="(max-width: 1920px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-480x270.webp" type="image/webp">
  <source media="(max-width: 2560px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-960x540.webp" type="image/webp">

  <source media="(max-width: 960px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-240x135.webp" type="image/jpeg">
  <source media="(max-width: 1920px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-480x270.webp" type="image/jpeg">
  <source media="(max-width: 2560px)" srcset="cache/webp/4271c8a52c6e4271ae912271f5e43f20-960x540.webp" type="image/jpeg">

  <img class="thumbnail-image" src="/assets/thumbnails-wide/tournament-event-01-2024.png" alt="">
</picture>
```

## Installation

Add this line to your site's Gemfile:

```ruby
# If you have any plugins, put them here!
group :jekyll_plugins do

    # (...)

    gem 'jekyll-transcode-image-filters', git: "https://github.com/Garanas/jekyll-transcode-image-filters"
end
```

:warning: If you are using Jekyll < 3.5.0 use the `gems` key instead of `plugins`.

## References

- [Responsive images by MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Responsive_images)
- [Optimize Cumulative Layout Shift](https://web.dev/articles/optimize-cls)
- []

### Guides

- [Your first Jekyll plugin](https://perseus333.github.io/blog/jekyll-first-plugin)

### Similar plugins

- [Jekyll Assets](https://github.com/envygeeks/jekyll-assets)
- [Jekyll Resize](https://github.com/MichaelCurrin/jekyll-resize)
