import { IconButton } from "@mui/material";

// A promotional banner shown at the top of the storefront: a hero image, a
// dismiss button, a quick email-capture field, and a "learn more" link. It looks
// finished, but every interactive piece here is invisible to assistive tech.
// Each defect below is a distinct web rule, planted for the Binclusive CI check.
export function BrokenBanner() {
  return (
    <aside className="promo-banner">
      {/* jsx-a11y/alt-text — WCAG 1.1.1: the promo artwork has no `alt`, so a
          screen reader falls back to reading "promo.png" or nothing at all.
          FIX: alt="Summer sale — 30% off" (or alt="" if purely decorative). */}
      <img src="/promo.png" width={960} height={200} />

      {/* enforce/button-no-name — WCAG 4.1.2: the dismiss control's only child is
          an aria-hidden <svg>, so it announces as "button" with no label.
          FIX: <IconButton aria-label="Dismiss banner" ...>. */}
      <IconButton className="promo-dismiss" onClick={() => {}}>
        <svg width="14" height="14" viewBox="0 0 14 14" aria-hidden="true">
          <path d="M3 3l8 8M11 3l-8 8" stroke="currentColor" />
        </svg>
      </IconButton>

      <form className="promo-capture">
        {/* enforce/input-no-name — WCAG 1.3.1 / 3.3.2: this email field has no
            <label>, no aria-label, and no placeholder-as-name, so it announces
            "edit text, blank".
            FIX: pair it with <label> or add aria-label="Email address". */}
        <input type="email" value="" onChange={() => {}} />
        <button type="submit">Notify me</button>
      </form>

      {/* jsx-a11y/anchor-has-content — WCAG 2.4.4: the link's only child is a
          CSS-drawn icon span with no text and no aria-label, so it announces
          "link" with no destination.
          FIX: give it real text, or aria-label="Learn more about the sale". */}
      <a href="/x" className="promo-more">
        <span className="icon" />
      </a>
    </aside>
  );
}
