// KNOWN-BAD build — the screens under Bad/ reproduce the real accessibility
// defects found in the shipping app, each tagged with the Binclusive rule it
// trips and the WCAG success criterion behind it.
//
// Not everything here is broken: where the shipping app gets it right, so does
// the clone. BadTabBar below is the notable case — it is deliberately correct
// and marked as such, so an audit has a control to compare against.
import SwiftUI

struct BadRootView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if state.selectedTab == 0 {
                    // swiftui/reading-order (WCAG 1.3.2) — the header sorts BEHIND
                    // the page body, so the profile pill sits at the top of the
                    // screen but is the last thing VoiceOver reaches in the body:
                    // everything else is announced first, then the greeting, then
                    // the tab bar. Visual order and reading order disagree.
                    BadHomeTopBar()
                        .accessibilitySortPriority(-1)
                }
                content
                    .accessibilitySortPriority(0)
                BadTabBar()
                    .accessibilitySortPriority(-2)
            }
            .background(Theme.canvas)
            .navigationDestination(isPresented: $state.showResults) {
                BadFlightResultsView()
            }
        }
        .sheet(isPresented: $state.showRouteSheet) { BadRouteSelectionView() }
        .sheet(isPresented: $state.showDateSheet) { BadDateSelectionView() }
        .sheet(isPresented: $state.showPassengerSheet) { BadPassengerView() }
    }

    @ViewBuilder
    private var content: some View {
        switch state.selectedTab {
        case 0: BadHomeView()
        case 1: BadPlaceholderView(title: "Uçuşlarım", icon: "airplane")
        case 2: BadPlaceholderView(title: "Check-In", icon: "mappin.and.ellipse")
        case 3: BadPlaceholderView(title: "Kampanyalar", icon: "megaphone")
        default: BadPlaceholderView(title: "Daha Fazla", icon: "ellipsis")
        }
    }
}

/// NOT a defect fixture. The shipping tab bar is accessible and looks like a
/// flat white bar, so the clone does both: hand-built to match the screenshot
/// exactly (iOS 26 renders a real TabView as a floating glass bar, and
/// UITabBarAppearance no longer overrides that), with each tab a single named
/// button that reports its own selected state. Do not "fix" this.
struct BadTabBar: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(TabDefinition.items.enumerated()), id: \.offset) { index, item in
                Button {
                    state.selectedTab = index
                } label: {
                    TabItemArt(systemImage: item.icon,
                               title: item.title,
                               isSelected: state.selectedTab == index)
                }
                .buttonStyle(.plain)
                // the title names the tab; the glyph never leaks its symbol name
                .accessibilityLabel(item.title)
                // the yellow tint has a spoken equivalent
                .accessibilityAddTraits(state.selectedTab == index ? [.isSelected] : [])
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Theme.card)
        .overlay(alignment: .top) { Rectangle().fill(Theme.hairline).frame(height: 0.5) }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Ana menü")
    }
}

struct BadPlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 14) {
            // swiftui/image-no-label (WCAG 1.1.1) — informative image with no name.
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(Theme.brandYellowDeep)
            // swiftui/no-header-trait (WCAG 1.3.1) — screen title is not a header.
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.ink)
            Text("Bu bölüm demo kapsamı dışındadır.")
                // swiftui/low-contrast (WCAG 1.4.3) — 2.4:1 on white.
                .foregroundStyle(Theme.mutedLow)
                .font(.system(size: 14))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.canvas)
    }
}
