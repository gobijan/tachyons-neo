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

## Contrast Fallbacks

Where supported, [`contrast-color()`](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/contrast-color) derives black or white foregrounds from the selected seed. Older browsers keep explicit foreground defaults for the shipped palette. The layer still requires `light-dark()` and `color-mix()`.

When changing a seed, also provide its matching `--on-*` foreground for browsers without `contrast-color()`. For example, a dark custom accent needs a light foreground:

```css
:root {
  --accent: #00449e;
}

@supports not (color: contrast-color(white)) {
  :root {
    --on-accent: white;
  }
}
```

Check text and focus contrast on the actual surface. A state color or muted text token alone is not a guarantee of readable body text.

The default focus color mixes the accent toward the theme's ink so it remains visible on the shipped surfaces in both themes. The browser check verifies at least [3:1 non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html) against each default surface. Override `--focus` directly when a custom palette needs a different focus color.

## Motion

`fade-y` reveals open popovers and dialogs. With reduced motion enabled, it changes visibility immediately without translation or transition. Core duration tokens also become `0s`, so token-based project animations follow the same preference.

## Migrating From v2.0.1

The app layer after v2.0.1 changes the public API. Treat this upgrade as a major version change and apply the migrations below before using it in production. The core utility names remain compatible.

| v2.0.1 | Current app layer |
| --- | --- |
| `action`, `bg-action`, `b--action`, `on-action`, and their hover forms | Use the corresponding `accent` forms. |
| `--action-light`, `--action-dark`, `--action` | Rename to `--accent-light`, `--accent-dark`, `--accent`. |
| `brand` utilities and `--brand-*` | Keep a project-owned brand color, or compose `bg-text-1 text-inverted` for a neutral treatment. |
| Individual `--text-*-light/dark` and `--border-*-light/dark` seeds | Set `--ink-light/dark`, or override a derived token such as `--text-2` directly. |
| Individual `--surface-1-light/dark` through `--surface-4-light/dark` | Set `--surface-base-light/dark` and `--ink-light/dark`, or override a derived surface token. Surfaces now mix opaque colors instead of using transparent overlays. |
| `--on-*-light/dark`, `--focus-light/dark` | Override the public `--on-*` or `--focus` token directly; use `light-dark()` for theme-specific values. |

The default accent is now light blue, shared with the focus seed; automatic contrast colors replace the old fixed action foregrounds. Review customized themes in both color schemes after upgrading. `fade-y` is new and is not available in v2.0.1.
