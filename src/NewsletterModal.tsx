import { useState } from "react";
import {
  Box,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  IconButton,
  TextField,
  Typography,
} from "@mui/material";

export function NewsletterModal() {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Button variant="text" onClick={() => setOpen(true)}>
        Join the newsletter
      </Button>

      <Dialog open={open} onClose={() => setOpen(false)}>
        <Box sx={{ display: "flex", justifyContent: "flex-end", p: 1 }}>
          <IconButton aria-label="Close" onClick={() => setOpen(false)}>
            <svg width="16" height="16" viewBox="0 0 16 16" aria-hidden="true">
              <path d="M4 4l8 8M12 4l-8 8" stroke="currentColor" strokeWidth="2" />
            </svg>
          </IconButton>
        </Box>
        <DialogContent sx={{ pt: 0 }}>
          <Typography variant="h6" sx={{ mb: 1 }}>
            Product updates, twice a month
          </Typography>
          <Typography sx={{ mb: 2, color: "#555" }}>
            The occasional email on what we shipped. No spam, ever.
          </Typography>
          <TextField label="Work email" fullWidth value="" onChange={() => {}} />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpen(false)}>Maybe later</Button>
          <Button variant="contained" onClick={() => setOpen(false)}>
            Subscribe
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
