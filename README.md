# Binclusive Starter

A clone-and-run demo of the **Binclusive accessibility engine**. It ships one
sample surface per stack — React/TSX, SwiftUI, Android XML, Shopify Liquid — and
each surface has a **known-bad file** with planted defects next to a **clean
control** with every defect fixed. Open a pull request and watch Binclusive flag
the bad files, leave the clean ones alone, annotate the diff, and land each
finding as a ticket on your dashboard.

This repo is the 0→100 walkthrough. Follow the steps below top to bottom.

---

## What's in here

| Stack | Bad fixture | Clean control | Rules it exercises |
|-------|-------------|---------------|--------------------|
| **React / TSX** | `src/Hero.tsx`, `src/IconButton.tsx`, `src/SignupForm.tsx`, `src/MoreLink.tsx` | fix each in place | `jsx-a11y/alt-text`, `jsx-a11y/anchor-has-content`, `enforce/button-no-name`, `enforce/input-no-name` |
| **SwiftUI** | `ios/BadView.swift` | `ios/GoodView.swift` | `swiftui/image-no-label`, `swiftui/control-no-name`, `swiftui/field-no-label`, `swiftui/color-only-state` |
| **Android XML** | `android/app/src/main/res/layout/bad_layout.xml` | `.../good_layout.xml` | `android-xml/image-no-label`, `android-xml/control-no-name` |
| **Shopify Liquid** | `shopify/bad.liquid` | `shopify/good.liquid` | `liquid/img-no-alt`, `liquid/empty-heading`, `liquid/input-no-label`, `liquid/iframe-no-title`, `liquid/positive-tabindex`, `liquid/control-no-name` |

The React defects live *inside* design-system components (MUI `IconButton`,
`TextField`). A plain `eslint-plugin-jsx-a11y` run is blind to those — Binclusive
reads the call site through the component and catches them anyway.

---

## 1. Install the CLI

```bash
npm i -g @binclusive/cli
```

This gives you the `b8e` command.

## 2. Log in

```bash
b8e login
```

Opens a browser to authenticate against your Binclusive org. One time per machine.

## 3. Wire the project

```bash
b8e init --all
```

`init --all` detects your stack and writes everything this repo already has:

- **`binclusive.json`** — the project config (detected stack + enforcement policy).
- **`.mcp.json`** — registers the Binclusive MCP server for your editor / agent.
- **`.github/workflows/a11y.yml`** — the CI Accessibility Agent workflow.

Re-running `init` is non-destructive: it preserves any enforcement and
declarations you've hand-tuned.

## 4. Connect the MCP server

The MCP server is how your editor / coding agent (Claude, Cursor, …) talks to
Binclusive while you work — audit a file, map the project, ask for a fix.

`b8e init --all` already wrote `.mcp.json`. To connect it in Claude Code
directly:

```bash
claude mcp add --transport http binclusive https://mcp.binclusive.io/mcp
```

Restart your editor afterward; it will open a browser once to authorize.

Once connected, four skills are available in the MCP / editor flow:

- **`map-project`** — inventory the accessibility surface of the whole repo.
- **`audit-accessibility`** — deep-audit a file or route and explain each finding.
- **`fix-accessibility`** — propose and apply the fix for a finding.
- **`shopify-theme-audit`** — Shopify-theme-specific audit across the Liquid set.

## 5. Provision the CI key

CI needs its own key (separate from your login).

1. Go to **`app.binclusive.io/<org>/settings/ci-access`** and create a CI key.
2. In this repo on GitHub: **Settings → Secrets and variables → Actions → New
   repository secret**.
3. Name it **`BINCLUSIVE_API_KEY`** and paste the key.

The workflow reads it from `secrets.BINCLUSIVE_API_KEY` — see
`.github/workflows/a11y.yml`.

## 6. Open a pull request

Change one of the bad fixtures (or just push this branch) and open a PR. On every
PR the CI agent:

- **Annotates the diff** — inline review comments on each finding, plus one
  rollup comment summarizing the run.
- **Uploads SARIF** — findings render as native GitHub code-scanning annotations
  on the **Files changed** tab.
- **Lands dashboard tickets** — each finding becomes a tracked ticket at
  `app.binclusive.io`, so nothing gets lost when the PR merges.

The workflow is **advisory** (`fail-on: warn`) — findings are reported but never
block the merge. Tighten enforcement in `binclusive.json` when you're ready.

---

## Try it: fix a bug, watch it clear

Each bad fixture has a `FIX:` comment telling you the one-line change. Fix one,
push, and watch that finding disappear from the PR while the others stay. Compare
any bad file against its clean control to see the finished state:

- `ios/BadView.swift` → `ios/GoodView.swift`
- `android/.../bad_layout.xml` → `android/.../good_layout.xml`
- `shopify/bad.liquid` → `shopify/good.liquid`
- `src/*.tsx` → apply each `FIX:` comment in place

Run the deterministic floor locally too:

```bash
pnpm install
pnpm scan
```

---

## Links

- Dashboard: `app.binclusive.io`
- CI access / keys: `app.binclusive.io/<org>/settings/ci-access`
- MCP endpoint: `https://mcp.binclusive.io/mcp`
- The action: [Binclusive/a11y](https://github.com/Binclusive/a11y)
