# Tachyons Neo

A small, composable CSS toolkit. Sharper defaults for modern viewports, finer-grained colour steps, a small CSS Grid layer, and a handful of utilities for prototyping. No build step, no dependencies, one stylesheet.

**Docs:** [screenisland.com/tachyons-neo](https://screenisland.com/tachyons-neo/) · **Upstream:** [tachyons.io](http://tachyons.io) v4.13.0 · **License:** MIT

---

## § 00 — Install

Drop the stylesheet in and go. There is no build step.

```html
<link rel="stylesheet" href="tachyons.css">
```

Or vendor it:

```sh
curl -O https://raw.githubusercontent.com/gobijan/tachyons-neo/main/tachyons.css
```

---

## § 01 — Patches

Nine additions on top of Tachyons v4.13.0.

| #  | Patch                      | Summary                                                                 |
|----|----------------------------|-------------------------------------------------------------------------|
| 01 | `-m` breakpoint            | No upper bound — `-m` styles continue applying at large unless overridden. |
| 02 | Gap scale                  | `.g0`–`.g7` for flex and grid, mapped to the spacing scale.             |
| 03 | Dynamic viewport heights   | `.dvh-25/50/75/100`, `.min-dvh-100` using the `dvh` unit.               |
| 04 | Hairline opacities         | `.black-025`, `.black-0125`, `.white-05/025/0125` + hover variants.     |
| 05 | Outlined type              | `.stroke` using `-webkit-text-stroke`.                                  |
| 06 | Grid system                | `.grid`, `.gtc1-4`, `.csp1-3`, `.csp-full`.                             |
| 07 | Filters & effects          | `.active-dim`, `.invert`, `.blur` (backdrop).                           |
| 08 | Form & list helpers        | `.resize-none`, `.list-inside`.                                         |
| 09 | Placeholder backgrounds    | `.random-image`, `.random-image-landscape`, `.random-image-portrait`.   |

Also: `.lh-headline` (tight leading for display type) and `.tnum` (tabular figures).

---

## § 02 — Tokens

Every design value — spacing, type scale, colours, radii, shadows, durations — is exposed as a `:root` custom property. Reference them from your own CSS:

```css
.card {
  padding: var(--spacing-3);
  color: var(--dark-pink);
  line-height: var(--lh-copy);
}
```

**118 tokens** across **18 groups**: spacing, font-size, measure, line-height, letter-spacing, radius, border-width, shadow, duration, grayscale, black/white alpha, warm, purple/pink, green, blue, washed, font families.

See [`tachyons.css`](tachyons.css) or the [live docs](https://screenisland.com/tachyons-neo/) for the full list.

---

## § 03 — Changelog

Release notes, newest first.

<!-- CHANGELOG:INSERT -->
### v1.0.1 — 2026-04-19

- Swapped `:focus` for `:focus-visible` on `.link`, all `.hover-*` color/bg utilities, and interactive helpers (`.dim`, `.glow`, `.grow`, `.grow-large`, `.hide-child`, `.underline-hover`, `.shadow-hover`, `.bg-animate`, `.nested-links a`) in `tachyons.css`.
- Added a Changelog section (§ 03) to `index.html` and `README.md`; renumbered Colophon to § 04.
- Linked the Source and Upstream entries in the Colophon and switched the footer Screen Island link to `dark-blue underline-hover`.


### v1.0.0 — 2026-04-19

- Initial release. Tachyons v4.13.0 with nine patches, a 118-token design system, and a small grid layer.

---

## § 04 — Colophon

A Screen Island edition of Tachyons. Descended from Tachyons (tachyons.io, 2016–) under the long shadow of Müller-Brockmann, Hofmann, and Crouwel. Built for internal use at [Screen Island](https://screenisland.com); published in case it's useful to you.

MIT.
