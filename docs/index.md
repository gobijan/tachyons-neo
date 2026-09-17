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

These CDN links match this documentation. {% if site.cdn_ref == 'main' %}`@main` follows unreleased development. {% endif %}For production, vendor both files together or pin both to the same published tag or full commit SHA.

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/gobijan/tachyons-neo@{{ site.cdn_ref }}/tachyons.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/gobijan/tachyons-neo@{{ site.cdn_ref }}/app.css">
```

## Mental Model

Tachyons Neo stays close to Tachyons: classes do one thing, compose directly in markup, and avoid component assumptions. Neo adds modern defaults where the original web has moved: container queries, dynamic viewport units, cascade layers, CSS variables, and a tiny grid layer.

## Browser Support

Core layout requires CSS cascade layers, inline-size container queries, and dynamic viewport units. The optional app layer also requires `light-dark()` and `color-mix()`. Check the browsers your product supports against those features.

`grid-lanes` is experimental and falls back to regular grid. Automatic `contrast-color()` foregrounds have explicit defaults for older browsers; custom themes must provide matching foreground overrides when that function is unavailable. See [App CSS]({{ '/docs/app-css/' | relative_url }}).

The popover demos additionally use the Popover API and CSS anchor positioning. Modal demos use native `dialog`. These examples target browsers with those platform features.

## Reduced Motion

When `prefers-reduced-motion: reduce` is active, Neo sets its three duration tokens to `0s`, removes interaction scaling, and opens popovers without entrance motion. Token-based animations in the demos follow the same preference. Project CSS that overrides durations or adds animations should also respect it.

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
