---
title: Responsive
section: Modules
summary: "Responsive suffixes use container queries in Neo, with the page as the default query container."
---

## Suffixes

| Suffix | Query |
| --- | --- |
| `-ns` | `@container (min-width: 30em)` |
| `-m` | `@container (min-width: 48em)` |
| `-l` | `@container (min-width: 64em)` |

Unlike the original medium range, Neo's `-m` has no upper bound. A medium utility continues at large sizes unless a later `-l` utility overrides it.

```html
<div class="pa3 pa5-m pa6-l">
  Padding increases at medium, then again at large.
</div>
```

## Responsive Families

Most core utilities have responsive forms. Add the suffix to the class name: `db-l`, `pa4-ns`, `gtc3-m`, `dark-blue-l`.

| Family | Examples |
| --- | --- |
| Aspect ratio and media | `aspect-ratio--16x9-l`, `object-cover-ns`, `bg-center-m` |
| Border and radius | `ba-l`, `bw2-ns`, `br3-m`, `b--dashed-l` |
| Display and flex | `dn-ns`, `flex-l`, `items-center-m`, `justify-between-l` |
| Grid and gap | `grid-l`, `gtc4-l`, `csp2-m`, `g3-ns` |
| Width and height | `w-50-l`, `mw7-ns`, `dvh-100-m`, `min-w-0-l` |
| Position and overflow | `absolute-l`, `sticky-ns`, `overflow-auto-m` |
| Color | `dark-blue-l`, `bg-light-blue-ns`, `b--black-10-m` |
| Spacing | `pa4-l`, `mt5-m`, `nl3-ns` |
| Type | `f2-m`, `lh-copy-l`, `tc-ns`, `nowrap-l` |
| Interaction and effects | `dim-l`, `shadow-hover-ns`, `debug-grid-16-l` |

## Page-Level Behavior

The reset makes `html` an inline-size container. That means responsive utilities work at the page level without extra markup.

```css
html {
  container-type: inline-size;
}
```

## Component-Local Behavior

Add `root` to any component that should query its own width instead of the page.

```html
<article class="root ba b--black-10">
  <div class="grid-l gtc2-l g3">
    <h2 class="ma0">Local layout</h2>
    <p class="ma0">This switches when the article is wide enough.</p>
  </div>
</article>
```

This is the core Neo difference: a responsive component can live inside a sidebar, modal, split pane, or dashboard card and react to its own available space.

## Cascade Rule of Thumb

Responsive variants appear in `-ns`, then `-m`, then `-l` order. Later variants win when they set the same property at the same container size.

```html
<div class="w-100 w-50-m w-25-l">
  Full width by default, half from 48em, quarter from 64em.
</div>
```
