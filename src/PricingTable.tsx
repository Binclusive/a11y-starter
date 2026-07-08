import { useState } from "react";
import {
  Box,
  Button,
  Card,
  CardContent,
  Container,
  FormControlLabel,
  Radio,
  RadioGroup,
  Typography,
} from "@mui/material";

const tiers = [
  { name: "Starter", monthly: 0, yearly: 0, blurb: "For side projects." },
  { name: "Team", monthly: 12, yearly: 120, blurb: "For growing squads." },
  { name: "Business", monthly: 29, yearly: 290, blurb: "For scaling orgs." },
];

export function PricingTable() {
  const [period, setPeriod] = useState<"monthly" | "yearly">("monthly");

  return (
    <Box component="section" id="pricing" sx={{ py: 8, bgcolor: "#f7f9fc" }}>
      <Container>
        <Typography variant="h4" component="h2" sx={{ mb: 3, fontWeight: 700 }}>
          Simple, honest pricing
        </Typography>

        <Box sx={{ mb: 4 }}>
          <Typography sx={{ mb: 1, fontWeight: 600 }}>Billing period</Typography>
          <RadioGroup
            row
            value={period}
            onChange={(e) => setPeriod(e.target.value as "monthly" | "yearly")}
          >
            <FormControlLabel value="monthly" control={<Radio />} label="Monthly" />
            <FormControlLabel
              value="yearly"
              control={<Radio />}
              label="Yearly (save 20%)"
            />
          </RadioGroup>
        </Box>

        <Box
          sx={{
            display: "grid",
            gap: 3,
            gridTemplateColumns: { xs: "1fr", md: "repeat(3, 1fr)" },
          }}
        >
          {tiers.map((t) => (
            <Card key={t.name} variant="outlined">
              <CardContent>
                <Typography variant="h6" component="h3">
                  {t.name}
                </Typography>
                <Typography sx={{ my: 1 }}>
                  <strong style={{ fontSize: "2rem" }}>
                    ${period === "monthly" ? t.monthly : t.yearly}
                  </strong>
                  <span style={{ color: "#777" }}>
                    /{period === "monthly" ? "mo" : "yr"}
                  </span>
                </Typography>
                <Typography sx={{ mb: 2, color: "#555" }}>{t.blurb}</Typography>
                <Button variant="contained" fullWidth href="#signup">
                  Choose {t.name}
                </Button>
              </CardContent>
            </Card>
          ))}
        </Box>
      </Container>
    </Box>
  );
}
