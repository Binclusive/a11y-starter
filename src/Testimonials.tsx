import { Box, Card, CardContent, Container, Typography } from "@mui/material";

const quotes = [
  {
    name: "Dana Whitfield",
    role: "Eng Lead, Loop",
    avatar: "/avatars/dana.jpg",
    quote:
      "We cut our planning meetings in half. Northwind is the first tool the whole team actually opens every morning.",
  },
  {
    name: "Marcus Reyes",
    role: "PM, Fathom",
    avatar: "/avatars/marcus.jpg",
    quote:
      "The automations paid for themselves in a week. I stopped chasing status updates entirely.",
  },
];

// NOTE: WCAG 1.1.1 — the avatar <img> below ships without alt text (blatant,
// the deterministic floor catches this via jsx-a11y/alt-text).
export function Testimonials() {
  return (
    <Box component="section" sx={{ py: 8 }}>
      <Container>
        <Typography variant="h4" component="h2" sx={{ mb: 4, fontWeight: 700 }}>
          Loved by fast-moving teams
        </Typography>
        <Box
          sx={{
            display: "grid",
            gap: 3,
            gridTemplateColumns: { xs: "1fr", md: "repeat(2, 1fr)" },
          }}
        >
          {quotes.map((q) => (
            <Card key={q.name} variant="outlined">
              <CardContent>
                <Typography sx={{ mb: 2, fontStyle: "italic" }}>
                  “{q.quote}”
                </Typography>
                <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                  <img
                    src={q.avatar}
                    width={40}
                    height={40}
                    style={{ borderRadius: "50%" }}
                  />
                  <Box>
                    <Typography sx={{ fontWeight: 600 }}>{q.name}</Typography>
                    <Typography sx={{ color: "#777", fontSize: "0.9rem" }}>
                      {q.role}
                    </Typography>
                  </Box>
                </Box>
              </CardContent>
            </Card>
          ))}
        </Box>
      </Container>
    </Box>
  );
}
