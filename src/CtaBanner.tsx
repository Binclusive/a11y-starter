import { Box, Button, Container, Stack } from "@mui/material";

export function CtaBanner() {
  return (
    <Box component="section" sx={{ py: 6, bgcolor: "#eef2ff" }}>
      <Container>
        <Stack
          direction={{ xs: "column", sm: "row" }}
          spacing={2}
          alignItems="center"
          justifyContent="space-between"
        >
          <h1 style={{ margin: 0, fontSize: "1.75rem" }}>
            Ready to move faster?
          </h1>
          <Button variant="contained" size="large" href="#signup">
            Create your workspace
          </Button>
        </Stack>
      </Container>
    </Box>
  );
}
