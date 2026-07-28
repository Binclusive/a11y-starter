// KNOWN-BAD fixture — "Tarih Seçimi" sheet.
// A price calendar is the hardest control in the app to get right, and this
// version gets none of it right: no button semantics, no selected state, no
// currency in the spoken price, and unavailable days are still focusable.
import SwiftUI

struct BadDateSelectionView: View {
    @EnvironmentObject private var state: AppState

    private let months = TurkishCalendar.months(from: Date(), count: 6)

    var body: some View {
        VStack(spacing: 0) {
            header
            tripTypeSelector
            dateTabs
            calendarScroll
            footer
            confirmButton
        }
        .background(Theme.canvas)
    }

    private var header: some View {
        ZStack {
            // swiftui/no-header-trait (WCAG 1.3.1)
            Text("Tarih Seçimi")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
            HStack {
                Spacer()
                // swiftui/control-no-name (WCAG 4.1.2)
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { state.showDateSheet = false }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.brandYellow)
    }

    private var tripTypeSelector: some View {
        // swiftui/selection-not-exposed (WCAG 4.1.2) — same radio group defect as
        // the home screen: selection is a white capsule and nothing else.
        HStack(spacing: 0) {
            ForEach(TripType.allCases) { type in
                Button {
                    state.tripType = type
                    if type == .oneWay { state.returnDate = nil }
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
        .padding(.top, 14)
        .padding(.bottom, 16)
    }

    private var dateTabs: some View {
        HStack(spacing: 10) {
            dateTab(.departure)
            // swiftui/wrong-label (WCAG 1.1.1) — decorative glyph shipped with the
            // sprite name as its accessible name.
            Image(systemName: "calendar")
                .font(.system(size: 22))
                .foregroundStyle(Theme.ink)
                .accessibilityLabel("linexcalendar")
            dateTab(.arrival)
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 16)
    }

    private func dateTab(_ field: DateField) -> some View {
        let isActive = state.dateSheetFocus == field
        let value: String
        switch field {
        case .departure: value = state.departureDate.map(TurkishCalendar.compact) ?? "Seçiniz"
        case .arrival:   value = state.returnDate.map(TurkishCalendar.compact) ?? "Seçiniz"
        }

        // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) +
        // swiftui/selection-not-exposed (WCAG 4.1.2) — which leg you are editing
        // is conveyed by the yellow fill alone.
        return VStack(spacing: 2) {
            Text(field.title)
                .font(.system(size: 16, weight: .semibold))
            Text(value)
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundStyle(Theme.ink)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(isActive ? Theme.brandYellow : Theme.canvas)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(Rectangle())
        .onTapGesture { state.dateSheetFocus = field }
        .opacity(field == .arrival && state.tripType == .oneWay ? 0.4 : 1)
    }

    private var calendarScroll: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                ForEach(months, id: \.self) { month in
                    monthSection(month)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Theme.card)
    }

    private func monthSection(_ month: Date) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // swiftui/no-header-trait (WCAG 1.3.1) — "Temmuz 2026" is not a header,
            // so there is no way to jump between months with the rotor.
            Text(TurkishCalendar.monthTitle(month))
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
                .padding(.horizontal, 18)

            // swiftui/decorative-image-exposed (WCAG 1.1.1) — the weekday ruler is
            // presentational, but each abbreviation is focusable and VoiceOver
            // reads "Pt", "Sa", "Ça"… as meaningless syllables.
            HStack(spacing: 0) {
                ForEach(TurkishCalendar.shortWeekdays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.mutedAccessible)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 14) {
                ForEach(Array(TurkishCalendar.days(inMonthOf: month).enumerated()), id: \.offset) { _, day in
                    if let day {
                        dayCell(day)
                    } else {
                        Color.clear.frame(height: 44)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }

    private func dayCell(_ day: Date) -> some View {
        let fare = SampleData.fare(for: day)
        let isPast = fare == nil
        let isSelected = isSameDay(day, state.departureDate) || isSameDay(day, state.returnDate)
        let isCheap = (fare ?? 0) < 5_000 && !isPast

        return VStack(spacing: 2) {
            Text("\(TurkishCalendar.calendar.component(.day, from: day))")
                .font(.system(size: 17, weight: isPast ? .regular : .semibold))
                .foregroundStyle(isPast ? Theme.mutedLow : Theme.ink)
            // swiftui/wrong-label (WCAG 1.1.1) — the fare is read as a bare number
            // ("9,844") with no currency and no link to its date.
            Text(fare.map { Money.tl($0) } ?? "—")
                .font(.system(size: 12))
                .foregroundStyle(isCheap ? Theme.green : Theme.mutedAccessible)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Theme.brandYellow : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isToday(day) && !isSelected ? Theme.brandYellowDeep : .clear, lineWidth: 1.5)
        )
        .contentShape(Rectangle())
        // Grouping the cell as a container keeps the day and its fare adjacent:
        // "30" then "6,400" then "31". Without this the LazyVGrid sorts purely
        // by position, reading all seven day numbers in a row and only then the
        // seven prices — which divorces every fare from its date entirely.
        .accessibilityElement(children: .contain)
        // swiftui/split-element (WCAG 1.3.2) — the day and its fare are still two
        // separate stops rather than one named element, so the user hears a day
        // number, then a bare number, and has to infer that the second belongs
        // to the first.
        // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — day cells are not
        // buttons; swiftui/selection-not-exposed (WCAG 4.1.2) — the chosen day is
        // yellow and nothing more; sold-out days stay focusable and give no
        // feedback when tapped.
        .onTapGesture {
            guard !isPast else { return }
            state.selectDate(day)
        }
    }

    private var footer: some View {
        HStack(spacing: 10) {
            Image(systemName: "tag")
                .font(.system(size: 20))
                .foregroundStyle(Theme.mutedAccessible)
            VStack(alignment: .leading, spacing: 2) {
                (Text("\(state.origin?.id ?? "ESB") — \(state.destination?.id ?? "SAW") fiyatları ")
                    + Text("TL").bold()
                    + Text(" ile listelenmektedir."))
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.ink)
                // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — a link styled
                // as bold text.
                Text("Para Birimini Değiştir")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Theme.card)
    }

    private var confirmButton: some View {
        let ready = state.departureDate != nil && (state.tripType == .oneWay || state.returnDate != nil)
        // swiftui/no-status-announcement (WCAG 4.1.3) — the button only *looks*
        // disabled. It keeps the button trait with no "dimmed" state, and tapping
        // it while incomplete does nothing and says nothing.
        return Button {
            guard ready else { return }
            state.showDateSheet = false
        } label: {
            Text("Tarihleri Onayla")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(ready ? Theme.ink : Theme.mutedAccessible)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(ready ? Theme.brandYellow : Theme.hairline)
        }
    }

    private func isSameDay(_ lhs: Date, _ rhs: Date?) -> Bool {
        guard let rhs else { return false }
        return TurkishCalendar.calendar.isDate(lhs, inSameDayAs: rhs)
    }

    private func isToday(_ day: Date) -> Bool {
        TurkishCalendar.calendar.isDateInToday(day)
    }
}
