---
title: Documentation
section: Overview
summary: "Learn the small surface area: load the CSS, compose utilities, use container-query suffixes, and reach for app.css when product UI needs semantic tokens."
---

## Install

Use the core stylesheet by itself for utility-first prototypes and static pages.

```html
<link rel="stylesheet" href="/tachyons.css">
```

Load `app.css` after it when the interface needs semantic theme tokens, surfaces, text ramps, state colors, and focus helpers.

```html
<link rel="stylesheet" href="/tachyons.css">
<link rel="stylesheet" href="/app.css">
```

Pinned CDN links are best for production.

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/gobijan/tachyons-neo@v{{ site.version }}/tachyons.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/gobijan/tachyons-neo@v{{ site.version }}/app.css">
```

## Mental Model

Tachyons Neo stays close to Tachyons: classes do one thing, compose directly in markup, and avoid component assumptions. Neo adds modern defaults where the original web has moved: container queries, dynamic viewport units, cascade layers, CSS variables, and a tiny grid layer.

## Modules

<div class="grid-l gtc2-l g3">
{% for module in site.data.modules %}
  <a href="{{ module.url | relative_url }}" class="db link near-black bg-white hover-bg-light-blue ba b--black-10 pa3 shadow-hover">
    <h2 class="f5 ttu tracked fw7 mt0 mb2">{{ module.title }}</h2>
    <p class="ma0 lh-copy">{{ module.summary }}</p>
    <p class="code f6 mt3 mb0">{{ module.classes }}</p>
  </a>
{% endfor %}
</div>

## Demos

The demo files are still plain HTML and keep their existing URLs.

| Demo | Platform features |
| --- | --- |
{% for demo in site.data.demos -%}
| [{{ demo.title }}]({{ demo.url | relative_url }}) | {{ demo.features }} |
{% endfor %}
