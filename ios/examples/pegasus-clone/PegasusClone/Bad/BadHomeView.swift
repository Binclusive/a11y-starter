// KNOWN-BAD fixture — the Pegasus home screen exactly as it ships today.
// Looks right, reads as a wall of unlabelled static text under VoiceOver.
import SwiftUI

struct BadHomeView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                hero
                searchCard
                    .padding(.horizontal, 12)
                    .offset(y: -20)
                promoRows
                    .padding(.horizontal, 12)
                    .padding(.bottom, 24)
                    .offset(y: -8)
            }
        }
        .background(Theme.canvas)
        .scrollIndicators(.hidden)
    }

    // MARK: - Hero

    private var hero: some View {
        VStack(spacing: 10) {
            // swiftui/hidden-content (WCAG 1.1.1) — the whole campaign canvas is
            // invisible to VoiceOver. It is the largest thing on the screen and
            // the only announcement of the current promotion, and it cannot be
            // reached or read at all.
            PromoBannerArt()
                .accessibilityHidden(true)

            PageDots(count: 5, index: 0)
                .padding(.bottom, 26)
        }
        .background(Theme.brandYellow)
    }

    // MARK: - Search card

    private var searchCard: some View {
        VStack(spacing: 0) {
            recentSearches
            tripTypeSelector
            routeRow
            ticketDivider
            dateRow
            passengerRow
            searchButton
        }
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    }

    private var recentSearches: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(SampleData.recentSearches) { search in
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 6) {
                                Text(search.origin)
                                    .font(.system(size: 15, weight: .semibold))
                                // swiftui/wrong-label (WCAG 1.1.1) — the glyph
                                // separating origin from destination is purely
                                // decorative, but it is exposed as an image named
                                // after the artwork: "filled tiny arrow". It lands
                                // mid-sentence, so the row reads "Ankara, filled
                                // tiny arrow, İstanbul Tümü".
                                Image(systemName: "airplane")
                                    .font(.system(size: 11))
                                    .accessibilityLabel("filled tiny arrow")
                                Text(search.destination)
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundStyle(Theme.ink)
                            HStack(spacing: 12) {
                                Text(search.dateText)
                                Text(search.passengerText)
                            }
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.mutedLow)
                        }
                        // swiftui/control-no-name (WCAG 4.1.2) — "remove recent
                        // search" control with no name and a 20pt hit area.
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Theme.mutedLow)
                            .onTapGesture { }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Theme.canvas)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(12)
        }
    }

    private var tripTypeSelector: some View {
        // swiftui/selection-not-exposed (WCAG 4.1.2) — this is a radio group, but
        // it is built from two plain Buttons. Nothing exposes the group, nothing
        // exposes which option is selected: the white pill is the only cue.
        HStack(spacing: 0) {
            ForEach(TripType.allCases) { type in
                Button {
                    state.tripType = type
                } label: {
                    Text(type.title)
                        .font(.system(size: 16, weight: state.tripType == type ? .bold : .regular))
                        .foregroundStyle(state.tripType == type ? Theme.ink : Theme.mutedLow)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(
                            Capsule().fill(state.tripType == type ? Color.white : Color.clear)
                                .shadow(color: .black.opacity(state.tripType == type ? 0.10 : 0), radius: 4, y: 1)
                        )
                }
            }
        }
        .padding(4)
        .background(Capsule().fill(Theme.canvas))
        .padding(.horizontal, 40)
        .padding(.bottom, 18)
    }

    private var routeRow: some View {
        HStack(spacing: 8) {
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — looks like a
            // heading, behaves like a button. VoiceOver announces static text, so
            // the user never learns it can be activated.
            Text(state.originText)
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(state.origin == nil ? Theme.ink : Theme.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .contentShape(Rectangle())
                .onTapGesture { state.openRouteSheet(.origin) }

            // The swap control announces as "change route, image".
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — it is an Image
            // with a tap gesture, so VoiceOver calls it an image and never says it
            // can be activated.
            // swiftui/untranslated-label (WCAG 3.1.2) — the name is an English
            // developer string sitting in an otherwise Turkish interface, so a
            // Turkish screen reader voice reads it as gibberish.
            // swiftui/small-touch-target (WCAG 2.5.8) — ~24pt hit area.
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 17))
                .foregroundStyle(Theme.mutedAccessible)
                .frame(width: 24, height: 24)
                .onTapGesture { state.swapRoute() }
                .accessibilityLabel("change route")

            Text(state.destinationText)
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .contentShape(Rectangle())
                .onTapGesture { state.openRouteSheet(.destination) }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
    }

    private var ticketDivider: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [6, 5]))
            .foregroundStyle(Theme.hairline)
            .frame(height: 1)
            .padding(.horizontal, 4)
    }

    private var dateRow: some View {
        HStack(spacing: 8) {
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — same defect as
            // the route row: interactive text with no button semantics.
            Text(state.departureText)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .contentShape(Rectangle())
                .onTapGesture { state.openDateSheet(.departure) }

            // swiftui/wrong-label (WCAG 1.1.1) — purely decorative calendar glyph
            // that should be hidden, but instead ships the sprite name as its
            // accessible name ("linexcalendar").
            Image(systemName: "calendar")
                .font(.system(size: 20))
                .foregroundStyle(Theme.mutedAccessible)
                .accessibilityLabel("linexcalendar")

            Text(state.returnText)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(state.tripType == .oneWay ? Theme.mutedLow : Theme.ink)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .lineLimit(1)
                .contentShape(Rectangle())
                .onTapGesture {
                    guard state.tripType == .roundTrip else { return }
                    state.openDateSheet(.arrival)
                }
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private var passengerRow: some View {
        VStack(alignment: .leading, spacing: 2) {
            Divider().padding(.bottom, 10)
            Text("Yolcular")
                .font(.system(size: 14))
                // swiftui/low-contrast (WCAG 1.4.3) — 2.4:1 label on white.
                .foregroundStyle(Theme.mutedLow)
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — interactive text.
            Text(state.passengers.summary)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .contentShape(Rectangle())
        .onTapGesture { state.showPassengerSheet = true }
    }

    private var searchButton: some View {
        Button {
            state.showResults = true
        } label: {
            Text("UCUZ UÇUŞ ARA")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.brandYellow)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        // swiftui/no-status-announcement (WCAG 4.1.3) — the button is always
        // enabled; if the form is incomplete nothing tells the user why the tap
        // appeared to do nothing.
        .padding(18)
    }

    // MARK: - Promos

    private var promoRows: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                DestinationPinArt()
                VStack(alignment: .leading, spacing: 1) {
                    Text("Nereye Gitsem?")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.mutedAccessible)
                    Text("Bütçene Göre Planla!")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Theme.ink)
                }
                Spacer()
                // swiftui/decorative-image-exposed (WCAG 1.1.1) — chevron read as
                // "chevron right" after the row text.
                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.ink)
            }
            .padding(14)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius))
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — whole card is
            // tappable but reads as four separate static elements.
            .onTapGesture { }

            HStack(spacing: 12) {
                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Theme.brandYellowDeep)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Pegasus ile")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.mutedAccessible)
                    Text("Nerelere Uçuyoruz?")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Theme.ink)
                }
                Spacer()
                Text("Yeni")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Theme.orange))
                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.ink)
            }
            .padding(14)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius))
            .onTapGesture { }
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

/// The yellow header. It is hoisted out of the scrolling content so that it
/// sits at the same level as the tab bar — which is what lets the tab bar sort
/// between it and the rest of the page.
struct BadHomeTopBar: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // swiftui/hidden-content (WCAG 1.1.1) — the brand logo is never
            // announced, so a VoiceOver user gets no confirmation of which app or
            // which screen they are on.
            PegasusLogo()
                .accessibilityHidden(true)

            Spacer(minLength: 8)

            // swiftui/over-grouped (WCAG 1.3.1 / 4.1.2) — the greeting, the point
            // balance and the account button are welded into ONE element that
            // announces "Hoş geldin AD SOYAD, 4,957 BolPuan". The account
            // button is swallowed by the group: it gets no focus of its own and no
            // button trait, so there is no way to reach the account screen.
            HStack(spacing: 8) {
                VStack(alignment: .trailing, spacing: 0) {
                    // swiftui/fixed-font-size (WCAG 1.4.4) — hard-coded sizes with
                    // lineLimit(1); text does not grow with Dynamic Type.
                    (Text("Hoş geldin ").font(.system(size: 13))
                        + Text("AD SOYAD").font(.system(size: 13, weight: .bold)))
                        .lineLimit(1)
                    Text("4,957 BolPuan")
                        .font(.system(size: 13))
                        .lineLimit(1)
                }
                .foregroundStyle(Theme.ink)

                Image(systemName: "person.circle")
                    .font(.system(size: 26))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .accessibilityElement(children: .combine)

            // swiftui/hidden-content (WCAG 1.1.1) — the notification bell is not
            // in the accessibility tree at all, so notifications are unreachable
            // and the unread dot has no non-visual equivalent (WCAG 1.4.1).
            Image(systemName: "bell")
                .font(.system(size: 22))
                .foregroundStyle(Theme.ink)
                .overlay(alignment: .topTrailing) {
                    Circle().fill(Theme.bolBolRed).frame(width: 7, height: 7).offset(x: 2, y: -1)
                }
                .onTapGesture { }
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background(Theme.brandYellow)
    }
}
