import { Box, Button, Container, Stack, Typography } from "@mui/material";

// SEEDED BUG (3 of 3): image with no alt text — WCAG 1.1.1, jsx-a11y/alt-text.
// A blind user gets nothing for this image: no `alt`, no aria-label. Screen
// readers may read the filename instead, which is noise.
// FIX: add alt that conveys meaning — alt="Team collaborating at a whiteboard" —
// or alt="" if the image is purely decorative.
export function Hero() {
  return (
    <Box component="section" sx={{ py: 8, bgcolor: "#f7f9fc" }}>
      <Container>
        <Stack
          direction={{ xs: "column", md: "row" }}
          spacing={6}
          alignItems="center"
        >
          <Box sx={{ flex: 1 }}>
            <h1 style={{ fontSize: "2.75rem", margin: 0, lineHeight: 1.1 }}>
              Ship accessible products, faster
            </h1>
            <Typography sx={{ mt: 2, mb: 4, fontSize: "1.15rem", color: "#555" }}>
              Northwind gives your team a single workspace to plan, build, and
              measure — without the busywork.
            </Typography>
            <Stack direction="row" spacing={2}>
              <Button variant="contained" size="large" href="#pricing">
                Get started
              </Button>
              <Button variant="text" size="large" href="#demo">
                Watch demo
              </Button>
            </Stack>
          </Box>
          <Box sx={{ flex: 1 }}>
            <img src="/hero.png" width={640} height={360} />
          </Box>
        </Stack>
      </Container>
    </Box>
  );
}
