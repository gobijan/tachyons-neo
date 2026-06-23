---
layout: doc
title: Demos
section: Patterns
summary: "Canonical component patterns built with Tachyons Neo. Each demo remains a plain, self-contained HTML file."
permalink: /demos/
---

## Component Patterns

| Demo | Platform features |
| --- | --- |
{% for demo in site.data.demos -%}
| [{{ demo.title }}]({{ demo.url | relative_url }}) | {{ demo.features }} |
{% endfor %}

## Conventions

- One pattern per file.
- Stylesheet paths stay relative to the demo file.
- Prefer zero JavaScript; when JavaScript is unavoidable, keep it inline.
- Use Tachyons Neo tokens over hardcoded values where a token exists.
