import { IconButton } from "@mui/material";

// SEEDED BUG (2 of 3): icon-only button with no accessible name — WCAG 4.1.2,
// enforce/button-no-name. The button's only child is an aria-hidden <svg>, so a
// screen reader announces "button" with no label — a blind user can't tell it
// closes the dialog.
// FIX: add an accessible name, e.g. <IconButton aria-label="Close" ...>.
export function CloseButton() {
  return (
    <IconButton onClick={() => {}}>
      <svg width="16" height="16" viewBox="0 0 16 16" aria-hidden="true">
        <path d="M4 4l8 8M12 4l-8 8" stroke="currentColor" />
      </svg>
    </IconButton>
  );
}
