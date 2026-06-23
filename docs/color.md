---
title: Color
section: Modules
summary: "Color utilities map directly to named tokens for foregrounds, backgrounds, borders, and hover states."
---

## Foreground, Background, Border

Each named color exposes foreground, background, border, hover foreground, and hover background forms. Core Tachyons Neo does not include hover border-color utilities; those live in `app.css` for semantic app tokens.

```html
<p class="dark-blue">Foreground</p>
<p class="bg-light-blue near-black">Background</p>
<p class="ba b--dark-blue">Border</p>
```

| Form | Example |
| --- | --- |
| foreground | `blue`, `near-black`, `white-70` |
| background | `bg-blue`, `bg-near-black`, `bg-white-10` |
| border | `b--blue`, `b--near-black`, `b--white-10` |
| hover foreground | `hover-blue`, `hover-white` |
| hover background | `hover-bg-blue`, `hover-bg-white-10` |

Color inheritance and reset helpers are also available: `color-inherit`, `bg-transparent`, `bg-inherit`, `b--transparent`, `b--inherit`, `b--initial`, and `b--unset`.

## Palette

{% for group in site.data.colors %}
### {{ group.name }}

<div class="grid grid-l gtc4-l g3">
{% for color in group.colors %}
  <div class="ba b--black-10 bg-white">
    <div class="swatch flex items-end pa2 {{ color.text }} bg-{{ color.name }}">
      <code class="swatch-label">{{ color.name }}</code>
    </div>
    <div class="pa2 f6 lh-copy">
      <div><code>{{ color.name }}</code></div>
      <div><code>bg-{{ color.name }}</code></div>
      <div><code>b--{{ color.name }}</code></div>
      <div><code>hover-{{ color.name }}</code></div>
      <div><code>hover-bg-{{ color.name }}</code></div>
      <div class="silver"><code>{{ color.value }}</code></div>
    </div>
  </div>
{% endfor %}
</div>
{% endfor %}

## Alpha Steps

Neo adds low-alpha black and white steps for hairline UI. They are available as foreground, background, border, hover foreground, and hover background utilities.

| Black | White |
| --- | --- |
| `black-90` through `black-05` | `white-90` through `white-05` |
| `black-025` | `white-025` |
| `black-0125` | `white-0125` |

```html
<div class="bt b--black-025 bg-white-05">
  Quiet divider
</div>
```

## Stripes

Use striped helpers on repeated children.

| Class | Odd-row background |
| --- | --- |
| `striped--light-silver` | `light-silver` |
| `striped--moon-gray` | `moon-gray` |
| `striped--light-gray` | `light-gray` |
| `striped--near-white` | `near-white` |
| `stripe-light` | `white-10` |
| `stripe-dark` | `black-10` |

```html
<table class="collapse w-100">
  <tbody>
    <tr class="striped--near-white"><td>One</td></tr>
    <tr class="striped--near-white"><td>Two</td></tr>
  </tbody>
</table>
```
