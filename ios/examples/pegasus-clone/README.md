# Pegasus clone — a full-app SwiftUI fixture

`ios/BadView.swift` is a single-screen fixture with four planted defects. This is
the other end of the scale: a **runnable clone of a shipping airline app**, with
the accessibility defects its real VoiceOver audit turned up, reproduced in
place across four screens.

Nothing here is invented. Every defect was reported from a VoiceOver pass over
the real app and then verified in this clone by reading the live accessibility
tree, not by eyeballing the code.

```bash
open PegasusClone.xcodeproj      # Xcode 16+, iOS 17+, simulator only
```

---

## Screens

| Screen | File | What it is |
|--------|------|------------|
| Home | `PegasusClone/Bad/BadHomeView.swift` | campaign banner, recent searches, the flight-search form |
| Route picker | `PegasusClone/Bad/BadRouteSelectionView.swift` | "Rota seçiniz" sheet with live airport search |
| Date picker | `PegasusClone/Bad/BadDateSelectionView.swift` | "Tarih Seçimi" price calendar |
| Results | `PegasusClone/Bad/BadFlightResultsView.swift` | "Gidiş uçuşları" flight list |
| Passengers | `PegasusClone/Bad/BadPassengerView.swift` | "Yolcu Seçimi" stepper sheet |

Every defect carries an inline tag naming the rule and the WCAG criterion:

```swift
// swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — looks like a
// heading, behaves like a button. VoiceOver announces static text, so
// the user never learns it can be activated.
Text(state.originText)
    .onTapGesture { state.openRouteSheet(.origin) }
```

## Rules exercised

| Rule | Count | Example |
|------|-------|---------|
| `swiftui/tap-gesture-no-button-trait` | 12 | `Nereden?` / `Nereye?` are `Text` + `.onTapGesture` |
| `swiftui/no-header-trait` | 8 | no screen title or section title is a header |
| `swiftui/wrong-label` | 7 | calendar glyph named `linexcalendar`; separator named `filled tiny arrow` |
| `swiftui/selection-not-exposed` | 6 | Gidiş Dönüş / Tek Yön is a radio group with no selected state |
| `swiftui/control-no-name` | 5 | icon-only account, close and remove buttons |
| `swiftui/no-status-announcement` | 4 | search results and stepper limits change silently |
| `swiftui/low-contrast` | 3 | 2.4:1 placeholder grey on white |
| `swiftui/image-no-label` | 3 | informative glyphs with no accessible name |
| `swiftui/hidden-content` | 3 | logo, notification bell and campaign banner are invisible to VoiceOver |
| `swiftui/decorative-image-exposed` | 3 | chevrons and route-line glyphs are focusable |
| `swiftui/reading-order` | 2 | search results land last; the profile pill is announced after the page body |
| `swiftui/color-only-state` | 1 | sold-out flights are conveyed by 45% opacity alone |
| `swiftui/untranslated-label` | 1 | swap control is named `change route` in a Turkish UI |
| `swiftui/split-element` | 1 | a calendar day and its fare are two separate stops |
| `swiftui/no-disabled-state` | 1 | the stepper minus looks and reads identically at its lower bound |
| `swiftui/small-touch-target` | 1 | ~24pt swap control |
| `swiftui/over-grouped` | 1 | greeting + points + account button welded into one element |
| `swiftui/fixed-font-size` | 1 | hard-coded sizes with `lineLimit(1)` |
| `swiftui/field-no-label` | 1 | search field with an empty title |

## The two headline defects

**Search results land at the bottom of the accessibility tree.** In
`BadRouteSelectionView`, results are attached with `.overlay` on the scroll view,
so they are the *last* node in the tree even though they cover the top of the
screen — and the list underneath is never hidden. Measured: typing "Dub" puts the
first result at index 153, after all 34 airport rows.

**The price calendar reads every date away from its price.** `LazyVGrid` sorts
children by position, and a day number and its fare sit at different heights, so
VoiceOver sweeps the whole row of numbers and only then the whole row of prices:
`"6" "7" "8" "9" "10" "11" "12" "—" "—" …`.

## What is deliberately correct

Not everything is broken — the shipping app gets some things right, and so does
the clone. **`BadTabBar` is a control, not a fixture.** Each tab is one focusable
button named by its title, reporting its own selected state. An audit that
"fixes" it is producing a false positive.

## Known gaps

- The tab bar is hand-built rather than a `TabView`, so it announces
  `"Ana Sayfa", selected, button` — it does not get the native
  `"tab bar, 1 of 5"` phrasing. SwiftUI exposes no tab-bar accessibility trait,
  and on iOS 26 a real `TabView` renders as the floating glass bar, which does
  not match the app being cloned. `UITabBarAppearance` no longer overrides that.
- A few SF Symbols still leak their raw names (`person.circle`,
  `globe.europe.africa.fill`). Authentic, but currently untagged.
