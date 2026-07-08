import {
  Box,
  Button,
  Container,
  Stack,
  TextField,
  Typography,
} from "@mui/material";

// SEEDED BUG (1 of 3): unlabeled input — WCAG 1.3.1 / 3.3.2, enforce/input-no-name.
// The email TextField has no <label>, no `label` prop, and no aria-label, so a
// screen reader announces "edit text, blank" with no idea what to type. A plain
// eslint-a11y run is blind to this because it lives inside a design-system
// component; the Binclusive check reads the call site and catches it.
// FIX: give it a name, e.g. <TextField label="Email address" ... />.
export function SignupForm() {
  return (
    <Box component="section" id="signup" sx={{ py: 8, bgcolor: "#0f172a" }}>
      <Container maxWidth="sm">
        <Typography variant="h4" component="h2" sx={{ color: "#fff", mb: 1 }}>
          Start your free trial
        </Typography>
        <Typography sx={{ color: "#cbd5e1", mb: 4 }}>
          No credit card required. Cancel anytime.
        </Typography>
        <form>
          <Stack spacing={2}>
            <TextField
              label="Full name"
              value=""
              onChange={() => {}}
              fullWidth
              sx={{ bgcolor: "#fff", borderRadius: 1 }}
            />
            <TextField
              type="email"
              value=""
              onChange={() => {}}
              fullWidth
              sx={{ bgcolor: "#fff", borderRadius: 1 }}
            />
            <Button type="submit" variant="contained" size="large">
              Sign up
            </Button>
          </Stack>
        </form>
      </Container>
    </Box>
  );
}
