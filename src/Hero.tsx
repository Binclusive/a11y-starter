// SEEDED BUG (3 of 3): image with no alt text — WCAG 1.1.1, jsx-a11y/alt-text.
// A blind user gets nothing for this image: no `alt`, no aria-label. Screen
// readers may read the filename instead, which is noise.
// FIX: add alt that conveys meaning — alt="Team collaborating at a whiteboard" —
// or alt="" if the image is purely decorative.
export function Hero() {
  return (
    <section>
      <h1>Welcome</h1>
      <img src="/hero.png" width={640} height={360} />
    </section>
  );
}

// prove v0.1.2 action runs
