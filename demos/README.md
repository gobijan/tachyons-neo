# Demos

Canonical component patterns built with tachyons-neo. Reference for Rails/ERB work and for AI assistants grepping the repo for working examples.

## Conventions

- One pattern per file. Filename is a component noun (`dropdown.html`, `modal.html`, …).
- Each file is self-contained. Stylesheet path is `../tachyons.css`; demos for application tokens or helpers also load `../app.css`.
- Top-of-file comment names the platform primitives used, so searches for a given feature land on the canonical example.
- Prefer zero JS. When JS is unavoidable, inline it — no shared scripts.
- Use tachyons-neo tokens (`var(--duration-fast)`, `var(--spacing-3)`, etc.) over hardcoded values where a token exists.

## Index

| Demo                                 | Component      | Platform features                                                             |
|--------------------------------------|----------------|-------------------------------------------------------------------------------|
| [dropdown.html](dropdown.html)       | Dropdown       | Popover API, CSS Anchor Positioning, `.fade-y`, `allow-discrete`              |
| [modal.html](modal.html)             | Modal dialog   | `<dialog>` + `showModal()`, `::backdrop`, `form method="dialog"`, `@starting-style`, `overlay` + `allow-discrete` |
| [flash.html](flash.html)             | Flash / toast  | `@keyframes` slide-in, inline dismiss; pattern for Rails `flash.each`         |
| [buttons.html](buttons.html)         | Buttons        | Default, primary, small, large, and icon-only button-like links               |
| [card.html](card.html)               | Card           | Placeholder imagery, clipped radius, elevation, and stacked content           |
| [app.html](app.html)                 | App shell      | `app.css` semantic tokens, scoped `data-theme`, accent/state utilities, focus and popover motion helpers |
| [form-field.html](form-field.html)   | Form fields    | Canonical markup for `form_with` output; text/textarea/select/radio/checkbox + hint/error states |
| [inputs.html](inputs.html)           | Inputs         | Broad native input showcase using the small Neo grid layer                    |
| [tooltip.html](tooltip.html)         | Tooltip        | `.hide-child`/`.child` reveal, `:focus-within`, `visibility` + `allow-discrete` transition, absolute positioning |
