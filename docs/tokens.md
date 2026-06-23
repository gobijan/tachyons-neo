---
title: Tokens
section: Tokens
summary: "Every design value is available as a CSS custom property, so custom CSS can share the same system as the utilities."
---

## Token Groups

The token table mirrors the `:root` block in `tachyons.css`.

{% for group in site.data.token_groups %}
### {{ group.name }}

| Token | Value |
| --- | --- |
{% for token in group.tokens -%}
| `{{ token[0] }}` | `{{ token[1] }}` |
{% endfor %}
{% endfor %}

## Use Tokens In Project CSS

```css
.card {
  border-radius: var(--radius-2);
  box-shadow: var(--shadow-2);
  color: var(--near-black);
  padding: var(--spacing-3);
}
```

Tokens live in `@layer tachyons`, but custom properties resolve everywhere. Redefine a token in your own unlayered CSS when a project needs a different value.

```css
:root {
  --dark-blue: oklch(0.46 0.18 255);
}
```

## Cascade Layers

The layer order is fixed:

```css
@layer reset, tachyons, app, debug;
```

Reset rules lose to utilities, utilities lose to optional `app.css`, app helpers lose to debug helpers, and unlayered project CSS wins over layered CSS.
