---
title: Layout and Grid
section: Modules
summary: "Use display, flexbox, widths, overflow, and Neo's tiny grid layer to get structure quickly."
---

## Display

| Class | Output |
| --- | --- |
| `dn` | `display: none` |
| `di` | `display: inline` |
| `db` | `display: block` |
| `dib` | `display: inline-block` |
| `dit` | `display: inline-table` |
| `dt` | `display: table` |
| `dtc` | `display: table-cell` |
| `dt-row` | `display: table-row` |
| `dt-row-group` | `display: table-row-group` |
| `dt-column` | `display: table-column` |
| `dt-column-group` | `display: table-column-group` |
| `dt--fixed` | fixed-layout table with full width |
| `flex` | `display: flex` |
| `inline-flex` | `display: inline-flex` |
| `grid` | `display: grid` |
| `grid-lanes` | `display: grid-lanes` |

## Flex

Common flex primitives stay intentionally small.

| Group | Classes |
| --- | --- |
| Direction | `flex-column`, `flex-row`, `flex-column-reverse`, `flex-row-reverse` |
| Wrapping | `flex-wrap`, `flex-nowrap`, `flex-wrap-reverse` |
| Flex item | `flex-auto`, `flex-none`, `flex-grow-0`, `flex-grow-1`, `flex-shrink-0`, `flex-shrink-1` |
| Alignment | `items-start`, `items-end`, `items-center`, `items-baseline`, `items-stretch` |
| Self alignment | `self-start`, `self-end`, `self-center`, `self-baseline`, `self-stretch` |
| Justify | `justify-start`, `justify-end`, `justify-center`, `justify-between`, `justify-around` |
| Content | `content-start`, `content-end`, `content-center`, `content-between`, `content-around`, `content-stretch` |
| Order | `order-0` through `order-8`, `order-last` |

```html
<header class="flex justify-between items-baseline g3">
  <strong>Tachyons Neo</strong>
  <nav class="flex g3">...</nav>
</header>
```

## Grid

Neo adds equal-fraction, shrink-safe grid tracks and simple column spans.

| Class | Output |
| --- | --- |
| `gtc1` through `gtc4` | `repeat(n, minmax(0, 1fr))` |
| `csp1` through `csp3` | span one through three columns |
| `csp-full` | span the full grid |
| `g0` through `g7` | gap scale |

```html
<div class="grid-l gtc4-l g3">
  <aside class="csp1-l">Filters</aside>
  <main class="csp3-l min-w-0">Results</main>
</div>
```

## Aspect Ratio and Media

| Group | Classes |
| --- | --- |
| Aspect ratio | `aspect-ratio`, `aspect-ratio--16x9`, `aspect-ratio--9x16`, `aspect-ratio--4x3`, `aspect-ratio--3x4`, `aspect-ratio--6x4`, `aspect-ratio--4x5`, `aspect-ratio--4x6`, `aspect-ratio--8x5`, `aspect-ratio--5x8`, `aspect-ratio--7x5`, `aspect-ratio--5x7`, `aspect-ratio--1x1` |
| Background size | `cover`, `contain` |
| Object fit | `object-cover`, `object-contain` |
| Background position | `bg-center`, `bg-top`, `bg-right`, `bg-bottom`, `bg-left` |

```html
<img class="aspect-ratio--4x5 object-cover w-100" src="/photo.jpg" alt="">
```

## Width and Height

Use percentages for layout, spacing-based fixed sizes for controls, and dynamic viewport units for page shells.

| Pattern | Meaning |
| --- | --- |
| `w-10`, `w-20`, `w-25`, `w-30`, `w-33`, `w-34`, `w-40`, `w-50`, `w-60`, `w-70`, `w-75`, `w-80`, `w-90`, `w-100` | percentage widths |
| `w-third`, `w-two-thirds` | common thirds |
| `w1` through `w5`, `w-auto` | spacing-based widths and auto |
| `mw-100`, `mw1` through `mw9`, `mw-none` | max widths |
| `h1` through `h5`, `h-auto`, `h-inherit` | spacing-based heights and reset helpers |
| `h-25`, `h-50`, `h-75`, `h-100`, `min-h-100` | percentage heights |
| `vh-25`, `vh-50`, `vh-75`, `vh-100`, `min-vh-100` | viewport heights |
| `dvh-25`, `dvh-50`, `dvh-75`, `dvh-100`, `min-dvh-100` | dynamic viewport heights |
| `min-w-0`, `min-h-0` | allow flex/grid children to shrink |

## Overflow and Position

| Group | Classes |
| --- | --- |
| Overflow | `overflow-visible`, `overflow-hidden`, `overflow-scroll`, `overflow-auto` |
| X axis | `overflow-x-visible`, `overflow-x-hidden`, `overflow-x-scroll`, `overflow-x-auto` |
| Y axis | `overflow-y-visible`, `overflow-y-hidden`, `overflow-y-scroll`, `overflow-y-auto` |
| Position | `static`, `relative`, `absolute`, `fixed`, `sticky` |
| Fill | `absolute--fill` |

## Float, Clear, and Tables

| Group | Classes |
| --- | --- |
| Float | `fl`, `fr`, `fn` |
| Clear | `cl`, `cr`, `cb`, `cn`, `cf` |
| Table helpers | `collapse`, `dt`, `dtc`, `dt-row`, `dt--fixed` |

## Border, Radius, and Shadow

| Group | Classes |
| --- | --- |
| Border sides | `ba`, `bt`, `br`, `bb`, `bl`, `bn` |
| Border width | `bw0` through `bw5`, `bt-0`, `br-0`, `bb-0`, `bl-0` |
| Border style | `b--solid`, `b--dotted`, `b--dashed`, `b--none` |
| Radius | `br0` through `br4`, `br-100`, `br-pill`, `br--bottom`, `br--top`, `br--right`, `br--left`, `br-inherit`, `br-initial`, `br-unset` |
| Shadow | `shadow-1` through `shadow-5`, `shadow-hover` |

## Transforms, Opacity, and Z-Index

| Group | Classes |
| --- | --- |
| Opacity | `o-100`, `o-90`, `o-80`, `o-70`, `o-60`, `o-50`, `o-40`, `o-30`, `o-20`, `o-10`, `o-05`, `o-025`, `o-0` |
| Rotate | `rotate-45`, `rotate-90`, `rotate-135`, `rotate-180`, `rotate-225`, `rotate-270`, `rotate-315` |
| Z-index | `z-0` through `z-5`, `z-999`, `z-9999`, `z-max`, `z-inherit`, `z-initial`, `z-unset` |

## Neo Helpers

| Class | Output |
| --- | --- |
| `active-dim` | active-state opacity dimming |
| `invert` | `filter: invert(1)` |
| `blur` | backdrop blur |
| `resize-none` | disables textarea resizing |
| `list-inside` | list markers inside |
| `random-image`, `random-image-landscape`, `random-image-portrait` | placeholder image backgrounds |
