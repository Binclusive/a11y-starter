import { useState } from "react";
import { AppBar, Toolbar, Box, Button, Typography } from "@mui/material";

const links = [
  { label: "Product", href: "#product" },
  { label: "Pricing", href: "#pricing" },
  { label: "Docs", href: "#docs" },
];

export function NavBar() {
  const [open, setOpen] = useState(false);

  return (
    <AppBar position="static" color="default" elevation={1}>
      <Toolbar sx={{ gap: 3 }}>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>
          Northwind
        </Typography>

        <Box sx={{ display: { xs: "none", md: "flex" }, gap: 3, flexGrow: 1 }}>
          {links.map((l) => (
            <a key={l.href} href={l.href} style={{ textDecoration: "none", color: "#333" }}>
              {l.label}
            </a>
          ))}
          <a href="#features" style={{ textDecoration: "none", color: "#333" }}>
            Learn more
          </a>
        </Box>

        <Button variant="outlined" tabIndex={2} sx={{ ml: "auto" }}>
          Sign in
        </Button>

        {/* Mobile menu toggle */}
        <div
          onClick={() => setOpen((o) => !o)}
          style={{ display: "flex", cursor: "pointer", padding: 8 }}
        >
          <svg width="20" height="20" viewBox="0 0 20 20" aria-hidden="true">
            <path d="M3 5h14M3 10h14M3 15h14" stroke="currentColor" strokeWidth="2" />
          </svg>
        </div>
      </Toolbar>
      {open && (
        <Box sx={{ display: { md: "none" }, px: 2, pb: 2 }}>
          {links.map((l) => (
            <a key={l.href} href={l.href} style={{ display: "block", padding: "8px 0" }}>
              {l.label}
            </a>
          ))}
        </Box>
      )}
    </AppBar>
  );
}
