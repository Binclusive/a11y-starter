# Binclusive CI Accessibility Agent — starter

A runnable example: clone this, open a pull request, and watch the Binclusive
accessibility check find three intentionally-seeded bugs on your diff — inline
comments, a rollup summary, and native code-scanning annotations. No account, no
secret, no config. It takes under five minutes.

## Try it

1. **Use this template** — click **Use this template → Create a new repository**
   (or fork it). You get your own copy with the workflow already wired up.
2. **Open a pull request** that touches all three `src/*.tsx` files. The check
   scans the **changed** `.tsx` files on the PR — the diff, not the whole tree —
   so to see all three findings, make a trivial edit to each seeded component
   (keep the bug — e.g. add a blank line or a comment) and push. Touch only one
   file and you will see only that file's finding.
3. **Read the findings** on the PR — three surfaces, all on your own GitHub:

   | Where | What you see |
   |---|---|
   | **Inline PR comments** | One review comment per finding, on the exact changed line. |
   | **Rollup comment** | A single summary comment — counts, tiers, the headline. |
   | **Code-scanning annotations** | The SARIF upload renders findings as native annotations on the diff. |

   The scan is **advisory by default: it exits 0** and never blocks the merge.

4. **Fix one and watch it clear.** Apply the fix noted in each file's comment,
   push, and the finding disappears on the next run. That is the full loop:
   open a PR → see findings → fix → resolved.

## The three seeded bugs

Each `src` component carries exactly one intentional bug, clearly commented, all
caught by the deterministic floor with no config:

| File | Bug | Rule | WCAG |
|---|---|---|---|
| `src/SignupForm.tsx` | Unlabeled input — a `<TextField>` with no label or aria-label | `enforce/input-no-name` | 1.3.1, 3.3.2 |
| `src/IconButton.tsx` | Icon-only button with no accessible name | `enforce/button-no-name` | 4.1.2 |
| `src/Hero.tsx` | Image with no `alt` | `jsx-a11y/alt-text` | 1.1.1 |

The two `enforce/*` findings live **inside** design-system (`@mui/material`)
components — the kind a plain `eslint-plugin-jsx-a11y` run walks straight past.
Reading the call site to catch those is the point of the Binclusive check.

## Run it locally too (optional)

```bash
pnpm install
pnpm scan
```

It prints the same findings your PR will show.

## More

- Full CI quickstart, the optional lanes (AI enrichment, merge gating, branded
  comments, dashboard ingest), and supply-chain pinning:
  **[Binclusive/a11y → docs/QUICKSTART-CI.md](https://github.com/Binclusive/a11y/blob/main/docs/QUICKSTART-CI.md)**
- The action itself: **[Binclusive/a11y](https://github.com/Binclusive/a11y)**
  (this repo pins the released tag `Binclusive/a11y@v0.1.1`).
