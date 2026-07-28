// KNOWN-BAD fixture — "Rota seçiniz" sheet.
// Headline defect: live search results are appended as an overlay, so in the
// accessibility tree they land AFTER every row of the full airport list — a
// VoiceOver user has to swipe past ~30 elements to reach what they just typed.
import SwiftUI

struct BadRouteSelectionView: View {
    @EnvironmentObject private var state: AppState
    @State private var originQuery = ""
    @State private var destinationQuery = ""

    private var activeQuery: String {
        state.routeSheetFocus == .origin ? originQuery : destinationQuery
    }

    private var matches: [Airport] {
        let query = activeQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return [] }
        return SampleData.allAirports.filter {
            $0.city.localizedCaseInsensitiveContains(query) || $0.id.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            fields
            promoCard
            airportList
        }
        .background(Theme.canvas)
    }

    private var header: some View {
        ZStack {
            // swiftui/no-header-trait (WCAG 1.3.1) — sheet title is plain text.
            Text("Rota seçiniz")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
            HStack {
                Spacer()
                // swiftui/control-no-name (WCAG 4.1.2) — close control is a bare
                // glyph with a tap gesture: no name, no button trait.
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { state.showRouteSheet = false }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.brandYellow)
    }

    private var fields: some View {
        VStack(alignment: .leading, spacing: 18) {
            field(title: "Nereden?", text: $originQuery, field: .origin)
            field(title: "Nereye?", text: $destinationQuery, field: .destination)
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 14)
    }

    private func field(title: String, text: Binding<String>, field: RouteField) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(Theme.ink)
            // swiftui/field-no-label (WCAG 1.3.1 / 4.1.2) — the visual caption
            // above is a separate Text; the field itself has an empty title, so
            // VoiceOver announces only "metin alanı".
            TextField("", text: text, prompt: Text("Seçiniz").foregroundColor(Theme.mutedLow))
                .font(.system(size: 17))
                .foregroundStyle(Theme.ink)
                .onTapGesture { state.routeSheetFocus = field }
            Rectangle()
                .fill(state.routeSheetFocus == field ? Theme.brandYellowDeep : Theme.hairline)
                .frame(height: state.routeSheetFocus == field ? 2 : 1)
        }
    }

    private var promoCard: some View {
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
            Image(systemName: "chevron.right").foregroundStyle(Theme.ink)
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius))
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
        .onTapGesture { }
    }

    private var airportList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                sectionTitle("Son Aranan Havalimanları")
                ForEach(SampleData.recentAirports) { airport in
                    row(airport)
                }

                HStack {
                    sectionTitle("Tümü")
                    Spacer()
                    HStack(spacing: 4) {
                        Text("Nerelere Uçuyoruz?")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Theme.mutedAccessible)
                    .padding(.trailing, 18)
                    // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2)
                    .onTapGesture { }
                }

                ForEach(SampleData.allAirports) { airport in
                    row(airport)
                }
            }
            .padding(.bottom, 40)
        }
        .background(Theme.card)
        // swiftui/reading-order (WCAG 1.3.2) — THE headline bug. The result panel
        // is attached as an overlay on the scroll view, so it is the LAST node in
        // the accessibility tree even though it covers the top of the screen.
        // The obscured list underneath is never hidden either, so VoiceOver reads
        // all ~34 airport rows before ever reaching the search results.
        .overlay(alignment: .top) {
            if !matches.isEmpty {
                searchResults
            }
        }
    }

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Arama Sonuçları")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Theme.ink)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(matches) { airport in
                        row(airport)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card)
        // swiftui/no-status-announcement (WCAG 4.1.3) — no announcement of how
        // many results appeared; the change is silent.
    }

    private func sectionTitle(_ text: String) -> some View {
        // swiftui/no-header-trait (WCAG 1.3.1) — list section titles are not
        // headers, so rotor "Headings" navigation finds nothing on this screen.
        Text(text)
            .font(.system(size: 19, weight: .bold))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 8)
    }

    private func row(_ airport: Airport) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(airport.city)
                .font(.system(size: 19))
                .foregroundStyle(Theme.ink)
            Text(airport.country)
                .font(.system(size: 14))
                .foregroundStyle(Theme.mutedLow)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 7)
        .contentShape(Rectangle())
        // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — each result reads as
        // two unrelated static texts ("Ankara", then "Türkiye").
        .onTapGesture {
            state.select(airport)
            originQuery = ""
            destinationQuery = ""
        }
    }
}
