import { Box } from "@mui/material";
import { NavBar } from "./NavBar";
import { Hero } from "./Hero";
import { FeatureCards } from "./FeatureCards";
import { PricingTable } from "./PricingTable";
import { Testimonials } from "./Testimonials";
import { SignupForm } from "./SignupForm";
import { NewsletterModal } from "./NewsletterModal";
import { CtaBanner } from "./CtaBanner";
import { Footer } from "./Footer";

// Northwind — a small SaaS landing page. Realistic enough to demo two scan
// lanes on: a deterministic floor (jsx-a11y + enforce rules) that catches the
// blatant issues, and the corpus AI lane that surfaces the subtler ones.
export function App() {
  return (
    <>
      <NavBar />
      <main>
        <Hero />
        <FeatureCards />
        <PricingTable />
        <Testimonials />
        <SignupForm />
        <CtaBanner />
        <Box sx={{ py: 4, textAlign: "center" }}>
          <NewsletterModal />
        </Box>
      </main>
      <Footer />
    </>
  );
}
