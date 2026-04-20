# Demos

Canonical component patterns built with tachyons-neo. Reference for Rails/ERB work and for AI assistants grepping the repo for working examples.

## Conventions

- One pattern per file. Filename is a component noun (`dropdown.html`, `modal.html`, …).
- Each file is self-contained. Stylesheet path is `../tachyons.css`.
- Top-of-file comment names the platform primitives used, so searches for a given feature land on the canonical example.
- Prefer zero JS. When JS is unavoidable, inline it — no shared scripts.
- Use tachyons-neo tokens (`var(--duration-fast)`, `var(--spacing-3)`, etc.) over hardcoded values where a token exists.

## Index

| Demo                                 | Component      | Platform features                                                             |
|--------------------------------------|----------------|-------------------------------------------------------------------------------|
| [dropdown.html](dropdown.html)       | Dropdown       | Popover API, CSS Anchor Positioning, `@starting-style`, `allow-discrete`      |
| [modal.html](modal.html)             | Modal dialog   | `<dialog>` + `showModal()`, `::backdrop`, `form method="dialog"`, `@starting-style`, `overlay` + `allow-discrete` |
| [flash.html](flash.html)             | Flash / toast  | `@keyframes` slide-in, inline dismiss; pattern for Rails `flash.each`         |
| [form-field.html](form-field.html)   | Form fields    | Canonical markup for `form_with` output; text/textarea/select/radio/checkbox + hint/error states |
