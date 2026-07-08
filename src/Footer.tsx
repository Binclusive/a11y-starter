import { Box, Container, Stack, Typography } from "@mui/material";

const columns = [
  { title: "Product", items: ["Overview", "Pricing", "Changelog"] },
  { title: "Company", items: ["About", "Careers", "Blog"] },
];

export function Footer() {
  return (
    <Box component="footer" sx={{ py: 6, bgcolor: "#0f172a", color: "#cbd5e1" }}>
      <Container>
        <Stack direction={{ xs: "column", md: "row" }} spacing={6}>
          <Box sx={{ flex: 1 }}>
            <Typography sx={{ fontWeight: 700, color: "#fff", mb: 1 }}>
              Northwind
            </Typography>
            <Typography sx={{ fontSize: "0.9rem" }}>
              The workspace for teams that ship.
            </Typography>
            <Stack direction="row" spacing={2} sx={{ mt: 2 }}>
              <a href="https://twitter.com" aria-hidden="true" style={{ color: "#cbd5e1" }}>
                <svg width="20" height="20" viewBox="0 0 20 20">
                  <circle cx="10" cy="10" r="9" fill="currentColor" />
                </svg>
              </a>
              <a href="https://github.com" aria-hidden="true" style={{ color: "#cbd5e1" }}>
                <svg width="20" height="20" viewBox="0 0 20 20">
                  <rect x="2" y="2" width="16" height="16" rx="4" fill="currentColor" />
                </svg>
              </a>
            </Stack>
          </Box>

          {columns.map((col) => (
            <Box key={col.title}>
              <Typography sx={{ fontWeight: 600, color: "#fff", mb: 1 }}>
                {col.title}
              </Typography>
              {col.items.map((item) => (
                <a
                  key={item}
                  href="#"
                  style={{ display: "block", padding: "4px 0", color: "#cbd5e1" }}
                >
                  {item}
                </a>
              ))}
            </Box>
          ))}
        </Stack>

        <Typography sx={{ mt: 5, fontSize: "0.85rem", color: "#64748b" }}>
          Questions about migrating your data?{" "}
          <a href="#docs" style={{ color: "#94a3b8" }}>
            click here
          </a>
          .
        </Typography>
      </Container>
    </Box>
  );
}
