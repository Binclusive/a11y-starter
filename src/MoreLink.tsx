// SEEDED BUG (4 of 4): link with no discernible text — WCAG 2.4.4,
// jsx-a11y/anchor-has-content. The arrow glyph is drawn by CSS (a background
// image on `.arrow-icon-link`), so the anchor has no text content and no
// aria-label — a screen reader announces "link" with no destination.
// FIX: give the link real text, e.g. <a ...>Read the docs</a>, or add
// aria-label="Read the docs" if the label must stay visual-only.
export function MoreLink() {
  return <a href="/docs" className="arrow-icon-link" />;
}
