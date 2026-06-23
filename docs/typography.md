---
title: Typography
section: Modules
summary: "Type utilities cover scale, families, measure, leading, tracking, transforms, and display treatments."
---

## Type Scale

| Class | Token | Value |
| --- | --- | --- |
| `f-headline`, `f-6` | `--font-size-headline` | `6rem` |
| `f-subheadline`, `f-5` | `--font-size-subheadline` | `5rem` |
| `f1` | `--font-size-1` | `3rem` |
| `f2` | `--font-size-2` | `2.25rem` |
| `f3` | `--font-size-3` | `1.5rem` |
| `f4` | `--font-size-4` | `1.25rem` |
| `f5` | `--font-size-5` | `1rem` |
| `f6` | `--font-size-6` | `.875rem` |
| `f7` | `--font-size-7` | `.75rem` |

```html
<h1 class="f1 f-subheadline-m f-headline-l lh-headline ttu fw9">
  Tachyons <span class="stroke">Neo</span>
</h1>
```

## Families

| Class | Purpose |
| --- | --- |
| `sans-serif` | default system sans stack |
| `serif` | Georgia/Times stack |
| `system-sans-serif` | UI sans generic |
| `system-serif` | UI serif generic |
| `code` | UI monospace stack |
| `helvetica`, `avenir`, `athelas`, `georgia`, `times`, `courier`, `bodoni`, `calisto`, `garamond`, `baskerville` | named stacks |

## Measure and Leading

| Class | Output |
| --- | --- |
| `measure` | `max-width: 30em` |
| `measure-wide` | `max-width: 34em` |
| `measure-narrow` | `max-width: 20em` |
| `lh-solid` | solid leading |
| `lh-title` | title leading |
| `lh-copy` | copy leading |
| `lh-headline` | tight display leading |

## Weight, Style, and Transform

| Group | Classes |
| --- | --- |
| Weight | `normal`, `b`, `fw1` through `fw9` |
| Style | `i`, `fs-normal` |
| Decoration | `underline`, `no-underline`, `strike` |
| Transform | `ttc`, `ttl`, `ttu`, `ttn` |
| Tracking | `tracked`, `tracked-tight`, `tracked-mega` |
| Special | `small-caps`, `tnum`, `truncate`, `stroke` |

## Alignment, Whitespace, and Vertical Align

| Group | Classes |
| --- | --- |
| Text align | `tl`, `tr`, `tc`, `tj` |
| Whitespace | `ws-normal`, `nowrap`, `pre` |
| Vertical align | `v-base`, `v-mid`, `v-top`, `v-btm` |
| Overflow copy | `truncate`, `overflow-container` |

## Lists, Links, and Nested Copy

| Group | Classes |
| --- | --- |
| Lists | `list`, `list-inside` |
| Links | `link`, `underline-hover`, `nested-links` |
| Nested leading | `nested-copy-line-height`, `nested-headline-line-height` |
| Nested lists | `nested-list-reset` |
| Nested paragraphs | `nested-copy-indent`, `nested-copy-separator` |
| Nested media | `nested-img` |

## Interaction Type Helpers

| Class | Use |
| --- | --- |
| `dim` | fade interactive elements on hover/focus |
| `glow` | transition opacity up on hover/focus |
| `hide-child` with `.child` | reveal child content on hover, focus-within, or active |
| `grow`, `grow-large` | scale interactions |
| `pointer` | pointer cursor on hover |
