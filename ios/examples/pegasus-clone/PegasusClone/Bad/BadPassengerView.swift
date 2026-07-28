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
            VStack(spacing: 0) {
                ForEach(PassengerKind.allCases) { kind in
                    row(kind)
                    Rectangle()
                        .fill(Theme.hairline)
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                }
            }
            Spacer(minLength: 0)
            confirmButton
        }
        .background(Theme.card)
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
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Theme.ink)
                    .onTapGesture { state.showPassengerSheet = false }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Theme.brandYellow)
    }

    private func row(_ kind: PassengerKind) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                Text(kind.title)
                    .font(.system(size: 19))
                    .foregroundStyle(Theme.ink)
                Text(kind.subtitle)
                    .font(.system(size: 15))
                    // swiftui/low-contrast (WCAG 1.4.3)
                    .foregroundStyle(Theme.mutedLow)
            }

            Spacer(minLength: 8)

            // swiftui/wrong-label (WCAG 1.1.1) — "ic_minus_circle" is the sprite
            // name, not what the control does.
            // swiftui/tap-gesture-no-button-trait (WCAG 4.1.2) — no button trait.
            // swiftui/no-disabled-state (WCAG 4.1.2) — the minus looks and reads
            // exactly the same at the lower bound as above it. Nothing visual and
            // nothing programmatic says it is unavailable; the tap is a silent
            // no-op (swiftui/no-status-announcement, WCAG 4.1.3).
            stepperGlyph(systemName: "minus.circle",
                         tint: Theme.ink,
                         background: Theme.hairline,
                         label: "ic_minus_circle")
                .onTapGesture { state.setCount(state.count(for: kind) - 1, for: kind) }

            // The value is an island: nothing ties "1" to Yetişkin or to the two
            // glyphs beside it, and it never announces when it changes.
            Text("\(state.count(for: kind))")
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(width: 74)

            stepperGlyph(systemName: "plus.circle",
                         tint: Theme.orange,
                         background: Theme.card,
                         label: "ic_plus_circle")
                .onTapGesture { state.setCount(state.count(for: kind) + 1, for: kind) }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
    }

    private func stepperGlyph(systemName: String, tint: Color,
                              background: Color, label: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 26, weight: .regular))
            .foregroundStyle(tint)
            .frame(width: 52, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(background)
                    .shadow(color: .black.opacity(background == Theme.card ? 0.14 : 0),
                            radius: 3, y: 1)
            )
            .accessibilityLabel(label)
    }

    private var confirmButton: some View {
        Button {
            state.showPassengerSheet = false
        } label: {
            Text("Yolcuları Onayla")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(Theme.ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Theme.brandYellow)
        }
    }
}
