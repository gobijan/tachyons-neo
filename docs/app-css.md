---
title: App CSS
section: App Layer
summary: "app.css is the optional semantic layer for product interfaces: theme tokens, surfaces, text ramps, borders, states, and focus helpers."
---

## Load Order

Load `app.css` after `tachyons.css`.

```html
<link rel="stylesheet" href="/tachyons.css">
<link rel="stylesheet" href="/app.css">
```

It sits in `@layer app`, above core utilities and below debug helpers.

## Themes

By default, the root follows `prefers-color-scheme`. Force a theme on `html` or any subtree with `data-theme`.

```html
<main data-theme="dark" class="bg-surface-base text-1">
  ...
</main>
```

## Semantic Utilities

{% for group in site.data.app_utility_groups %}
### {{ group.name }}

| Tokens | Utilities |
| --- | --- |
| {% for token in group.tokens %}`{{ token }}`{% unless forloop.last %}, {% endunless %}{% endfor %} | {% for utility in group.utilities %}`{{ utility }}`{% unless forloop.last %}, {% endunless %}{% endfor %} |
{% endfor %}

Every semantic color token has foreground (`token`), background (`bg-token`), border (`b--token`), hover foreground (`hover-token`), hover background (`hover-bg-token`), and hover border (`hover-b--token`) forms. Accent and state colors also include `on-*` contrast helpers.

## Theme Seeds

| Seed | Light default | Dark default |
| --- | --- | --- |
| `--accent-*` | `light-blue` | `light-blue` |
| `--surface-base-*` | `white` | `oklch(0.08 0 0)` |
| `--ink-*` | `black` | `white` |
| `--danger-*` | `dark-red` | `light-red` |
| `--success-*` | `green` | `light-green` |
| `--warning-*` | `orange` | `yellow` |
| `--info-*` | `light-blue` | `light-blue` |

## Accent Overrides

Set one accent and the derived helpers follow.

```css
:root {
  --accent: oklch(0.62 0.22 255);
}
```

Or split the seed by theme.

```css
:root {
  --accent-light: oklch(0.58 0.23 255);
  --accent-dark: oklch(0.72 0.18 255);
}
```

## Example

```html
<section class="bg-surface-base text-1 ba b--border-1 pa3">
  <button class="button-reset bg-accent on-accent focus-ring ph3 pv2">
    Save
  </button>
</section>
```
