import { SignupForm } from "./SignupForm";
import { CloseButton } from "./IconButton";
import { Hero } from "./Hero";

// A tiny sample page. Each child component carries exactly one intentional,
// clearly-commented accessibility bug for the Binclusive CI check to find on
// your first pull request. Fix them one at a time and watch the findings clear.
export function App() {
  return (
    <main>
      <CloseButton />
      <Hero />
      <SignupForm />
    </main>
  );
}
