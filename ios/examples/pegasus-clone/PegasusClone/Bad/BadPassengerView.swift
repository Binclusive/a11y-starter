// KNOWN-BAD fixture — "Yolcu Seçimi" sheet.
// The stepper is the defect the audit called out: the +/- glyphs ship with the
// designer's asset names instead of an action name, and the count they change
// is a separate, unrelated text node.
import SwiftUI

struct BadPassengerView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(PassengerKind.allCases) { kind in
                        row(kind)
                        Divider().padding(.leading, 18)
                    }
                }
                .padding(.top, 6)
            }
            .background(Theme.card)
            confirmButton
        }
        .background(Theme.canvas)
    }

    private var header: some View {
        ZStack {
            // swiftui/no-header-trait (WCAG 1.3.1)
            Text("Yolcu Seçimi")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
            HStack {
                Spacer()
                // swiftui/control-no-name (WCAG 4.1.2)
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { state.showPassengerSheet = false }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.brandYellow)
    }

    private func row(_ kind: PassengerKind) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(kind.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                Text(kind.subtitle)
                    .font(.system(size: 13))
                    // swiftui/low-contrast (WCAG 1.4.3)
                    .foregroundStyle(Theme.mutedLow)
            }
            Spacer()

            // swiftui/wrong-label (WCAG 1.1.1) — "ic_minus_circle" is the sprite
            // name, not what the control does.
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — no button trait.
            // swiftui/color-only-state (WCAG 1.4.1) — "can't go lower" is grey.
            Image(systemName: "minus.circle")
                .font(.system(size: 28))
                .foregroundStyle(state.canDecrement(kind) ? Theme.brandYellowDeep : Theme.mutedLow)
                .accessibilityLabel("ic_minus_circle")
                .onTapGesture { state.setCount(state.count(for: kind) - 1, for: kind) }

            // The value is an island: nothing ties "1" to Yetişkin or to the two
            // glyphs beside it, and it never announces when it changes
            // (swiftui/no-status-announcement, WCAG 4.1.3).
            Text("\(state.count(for: kind))")
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(minWidth: 26)

            Image(systemName: "plus.circle")
                .font(.system(size: 28))
                .foregroundStyle(state.canIncrement(kind) ? Theme.brandYellowDeep : Theme.mutedLow)
                .accessibilityLabel("ic_plus_circle")
                .onTapGesture { state.setCount(state.count(for: kind) + 1, for: kind) }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }

    private var confirmButton: some View {
        Button {
            state.showPassengerSheet = false
        } label: {
            Text("Yolcuları Onayla")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.brandYellow)
        }
    }
}
