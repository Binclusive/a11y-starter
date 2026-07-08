import { Box, Card, CardContent, Container, Typography } from "@mui/material";

const features = [
  {
    title: "Realtime boards",
    body: "See every task move as your team works, with zero refreshes.",
  },
  {
    title: "Smart automations",
    body: "Route work automatically with rules anyone on the team can write.",
  },
  {
    title: "Insight dashboards",
    body: "Track velocity and cycle time without exporting a single CSV.",
  },
];

export function FeatureCards() {
  return (
    <Box component="section" id="features" sx={{ py: 8 }}>
      <Container>
        {/* Section heading jumps to h4 for the smaller type scale we use here */}
        <Typography variant="h4" component="h4" sx={{ mb: 1, fontWeight: 700 }}>
          Everything in one place
        </Typography>
        <Typography sx={{ mb: 5, color: "#aaa" }}>
          The building blocks your team already reaches for, together at last.
        </Typography>

        <Box
          sx={{
            display: "grid",
            gap: 3,
            gridTemplateColumns: { xs: "1fr", md: "repeat(3, 1fr)" },
          }}
        >
          {features.map((f) => (
            <Card key={f.title} variant="outlined">
              <CardContent>
                <img
                  src="/icons/spark.svg"
                  alt=""
                  width={32}
                  height={32}
                  style={{ marginBottom: 12 }}
                />
                <Typography variant="h6" component="h3" sx={{ mb: 1 }}>
                  {f.title}
                </Typography>
                <Typography sx={{ color: "#555" }}>{f.body}</Typography>
              </CardContent>
            </Card>
          ))}
        </Box>
      </Container>
    </Box>
  );
}
