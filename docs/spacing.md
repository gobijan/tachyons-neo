---
title: Spacing
section: Modules
summary: "Padding, margin, negative margin, and gap all share the same compact scale."
---

## Scale

The spacing scale is exposed as CSS custom properties and reused by padding, margin, width, height, position offsets, and gap.

| Step | Token | Value |
| --- | --- | --- |
| 0 | `--spacing-0` | `0` |
| 1 | `--spacing-1` | `.25rem` |
| 2 | `--spacing-2` | `.5rem` |
| 3 | `--spacing-3` | `1rem` |
| 4 | `--spacing-4` | `2rem` |
| 5 | `--spacing-5` | `4rem` |
| 6 | `--spacing-6` | `8rem` |
| 7 | `--spacing-7` | `16rem` |

## Padding

| Pattern | Meaning |
| --- | --- |
| `pa0` through `pa7` | all sides |
| `pl0` through `pl7` | left |
| `pr0` through `pr7` | right |
| `pt0` through `pt7` | top |
| `pb0` through `pb7` | bottom |
| `ph0` through `ph7` | horizontal |
| `pv0` through `pv7` | vertical |

All padding utilities have `-ns`, `-m`, and `-l` variants.

```html
<section class="ph3 ph4-ns pv4 pv5-l">
  Responsive page padding
</section>
```

## Margin

| Pattern | Meaning |
| --- | --- |
| `ma0` through `ma7` | all sides |
| `ml0` through `ml7` | left |
| `mr0` through `mr7` | right |
| `mt0` through `mt7` | top |
| `mb0` through `mb7` | bottom |
| `mh0` through `mh7` | horizontal |
| `mv0` through `mv7` | vertical |
| `ml-auto`, `mr-auto`, `mt-auto`, `mb-auto` | auto margins |

All scale-based margin utilities have `-ns`, `-m`, and `-l` variants. Auto-margin helpers also have responsive variants.

## Negative Margin

Negative margin mirrors the scale from 1 through 7.

| Pattern | Meaning |
| --- | --- |
| `na1` through `na7` | all sides |
| `nl1` through `nl7` | left |
| `nr1` through `nr7` | right |
| `nt1` through `nt7` | top |
| `nb1` through `nb7` | bottom |

Negative margin utilities have `-ns`, `-m`, and `-l` variants.

## Gap

Neo adds `g0` through `g7` for flex and grid gaps.

| Class | Value |
| --- | --- |
| `g0` | `0` |
| `g1` | `.25rem` |
| `g2` | `.5rem` |
| `g3` | `1rem` |
| `g4` | `2rem` |
| `g5` | `4rem` |
| `g6` | `8rem` |
| `g7` | `16rem` |

```html
<div class="grid grid-l gtc3-l g3 g4-l">
  <article>One</article>
  <article>Two</article>
  <article>Three</article>
</div>
```

## Position Offsets

Offset utilities use spacing steps 3 and 4 for one- and two-step offsets.

| Class | Value |
| --- | --- |
| `top-0`, `right-0`, `bottom-0`, `left-0` | `0` |
| `top-1`, `right-1`, `bottom-1`, `left-1` | `1rem` |
| `top-2`, `right-2`, `bottom-2`, `left-2` | `2rem` |
| `top--1`, `right--1`, `bottom--1`, `left--1` | `-1rem` |
| `top--2`, `right--2`, `bottom--2`, `left--2` | `-2rem` |

```html
<div class="relative">
  <button class="absolute top-1 right-1">Close</button>
</div>
```
