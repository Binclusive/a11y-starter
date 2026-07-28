// KNOWN-BAD fixture — "Gidiş uçuşları" results list.
// Each flight card is a mosaic of ~8 independent static texts. VoiceOver reads
// "ESB", "13:15", "Direkt Uçuş", "3sa 20dk", "SAW", "17:35", "11,511.00 TL"
// with nothing saying which airport is departure and which is arrival.
import SwiftUI

struct BadFlightResultsView: View {
    @EnvironmentObject private var state: AppState
    @State private var selectedDateIndex = 1
    @State private var payWithPoints = false

    private var flights: [Flight] { state.resultFlights }

    var body: some View {
        VStack(spacing: 0) {
            header
            dateStrip
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    monthlyPricesRow
                    bolPuanCard
                    routeTitle
                    sectionTitle("Direkt Uçuşlar")
                    ForEach(flights.filter { $0.connection == nil }) { flight in
                        flightCard(flight)
                    }
                    sectionTitle("Aktarmalı Uçuşlar")
                    ForEach(flights.filter { $0.connection != nil }) { flight in
                        flightCard(flight)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 30)
            }
        }
        .background(Theme.canvas)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        ZStack {
            // swiftui/no-header-trait (WCAG 1.3.1)
            Text("Gidiş uçuşları")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
            HStack {
                // swiftui/control-no-name (WCAG 4.1.2) — back control with no name.
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { state.showResults = false }
                Spacer()
                // swiftui/wrong-label (WCAG 1.1.1) — filter icon named after the
                // asset, and the "filters are active" state is not exposed at all.
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .accessibilityLabel("ic_filter")
                    .padding(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Theme.ink, lineWidth: 1.5))
                    .onTapGesture { }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.brandYellow)
    }

    private var dateStrip: some View {
        // swiftui/selection-not-exposed (WCAG 4.1.2) — the active day is an orange
        // underline. swiftui/tap-gesture-no-button-trait (WCAG 4.1.2).
        HStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { index in
                let day = TurkishCalendar.calendar.date(byAdding: .day, value: index + 2, to: Date()) ?? Date()
                VStack(spacing: 3) {
                    Text(TurkishCalendar.shortLabel(day))
                        .font(.system(size: 17, weight: selectedDateIndex == index ? .bold : .regular))
                        .foregroundStyle(selectedDateIndex == index ? Theme.ink : Theme.mutedAccessible)
                    Text("\(Money.tl(SampleData.fare(for: day) ?? 9_844)).00 TL")
                        .font(.system(size: 15))
                        .foregroundStyle(selectedDateIndex == index ? Theme.ink : Theme.mutedAccessible)
                    Rectangle()
                        .fill(selectedDateIndex == index ? Theme.orange : Color.clear)
                        .frame(height: 3)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { selectedDateIndex = index }
            }
        }
        .padding(.top, 10)
        .background(Theme.card)
    }

    private var monthlyPricesRow: some View {
        HStack(spacing: 12) {
            // swiftui/image-no-label (WCAG 1.1.1)
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 26))
                .foregroundStyle(Theme.brandYellowDeep)
            VStack(alignment: .leading, spacing: 1) {
                Text("Aylık Fiyatları İncele")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                Text("Uçuşları takvim / grafik üzerinde gör")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.mutedLow)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.ink)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture { }
    }

    private var bolPuanCard: some View {
        HStack(spacing: 12) {
            BolBolLogo()
            VStack(alignment: .leading, spacing: 1) {
                Text("4,957.77")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(Theme.ink)
                Text("BolPuan'ınız var")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.mutedLow)
            }
            Spacer()
            // swiftui/selection-not-exposed (WCAG 4.1.2) — currency toggle is a
            // two-option radio group with no group, no role and no selected state.
            HStack(spacing: 0) {
                currencyChip("TL", selected: !payWithPoints) { payWithPoints = false }
                currencyChip("BolPuan", selected: payWithPoints) { payWithPoints = true }
            }
            .padding(3)
            .background(Capsule().fill(Theme.canvas))
        }
        .pegasusCard(padding: 12)
    }

    private func currencyChip(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(selected ? .white : Theme.mutedAccessible)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(selected ? Theme.orange : Color.clear))
            .onTapGesture(perform: action)
    }

    private var routeTitle: some View {
        // swiftui/no-header-trait (WCAG 1.3.1) — "Ankara - İstanbul" is the
        // context for everything below it, but it is not a header.
        Text("\(state.origin?.display ?? "Ankara") - \(state.destination?.display ?? "İstanbul")")
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(Theme.ink)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Theme.mutedAccessible)
    }

    private func flightCard(_ flight: Flight) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(flight.originCode)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.mutedAccessible)
                    Text(flight.departure)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Theme.ink)
                }
                Spacer()
                VStack(spacing: 4) {
                    Text(flight.connection ?? "Direkt Uçuş")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.mutedAccessible)
                    HStack(spacing: 4) {
                        // swiftui/decorative-image-exposed (WCAG 1.1.1) — the
                        // route line glyphs are read as "circle" and "arrow right".
                        Image(systemName: "circle.fill").font(.system(size: 6))
                        Rectangle().frame(width: 14, height: 1)
                        Text(flight.duration).font(.system(size: 14))
                        Image(systemName: "arrow.right").font(.system(size: 11))
                    }
                    .foregroundStyle(Theme.mutedAccessible)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(flight.destinationCode)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.mutedAccessible)
                    Text(flight.arrival)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(Theme.ink)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            if let layover = flight.layover {
                HStack {
                    Text(flight.connection ?? "")
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                    Text(layover).font(.system(size: 14))
                }
                .foregroundStyle(Theme.mutedAccessible)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            } else {
                Divider().padding(.horizontal, 16)
                HStack {
                    // swiftui/image-no-label (WCAG 1.1.1) — the "free cancellation
                    // within 24h" badge is a bare glyph with no name.
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                        .font(.system(size: 22))
                        .foregroundStyle(Theme.mutedAccessible)
                    Spacer()
                    if flight.isCheapest {
                        // swiftui/wrong-label (WCAG 1.1.1) — the star means "en
                        // ucuz uçuş" but is announced as "star fill".
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Theme.brandYellowDeep)
                    }
                    Text("\(Money.tlWithDecimals(flight.price)) TL")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(flight.isCheapest ? Theme.green : Theme.ink)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius))
        // swiftui/color-only-state (WCAG 1.4.1) — a sold-out flight is 45% opacity
        // and nothing else; it stays focusable and silently ignores taps.
        .opacity(flight.soldOut ? 0.45 : 1)
        .contentShape(Rectangle())
        .onTapGesture { }
    }
}
