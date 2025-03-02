---
layout: default
title: "Happy Jekylling!"
---

## You're ready to go!

Start developing your Jekyll website.

<picture>
 {% assign imagePath = "assets/images/cybran-test-image.png" %}

  <!-- Keep it small to reduce test time -->
  <source media="(max-width: 960px)" srcset="{{ imagePath | avif: "240x135" | relative_url }}" type="image/avif">
  <source media="(max-width: 960px)" srcset="{{ imagePath | webp: "240x135" | relative_url }}" type="image/webp">
  <source media="(max-width: 960px)" srcset="{{ imagePath | jpg: "240x135" | relative_url }}" type="image/jpeg">

  <img class="thumbnail-image" src="{{ imagePath | relative_url }}" alt="{{include.alt}}">
</picture>