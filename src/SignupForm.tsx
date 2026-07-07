import { TextField, Button } from "@mui/material";

// SEEDED BUG (1 of 3): unlabeled input — WCAG 1.3.1 / 3.3.2, enforce/input-no-name.
// The email TextField has no <label>, no `label` prop, and no aria-label, so a
// screen reader announces "edit text, blank" with no idea what to type. A plain
// eslint-a11y run is blind to this because it lives inside a design-system
// component; the Binclusive check reads the call site and catches it.
// FIX: give it a name, e.g. <TextField label="Email address" ... />.
export function SignupForm() {
  return (
    <form>
      <TextField type="email" value={""} onChange={() => {}} />
      <Button type="submit">Sign up</Button>
    </form>
  );
}
