// KNOWN-BAD fixture — every view here trips a Binclusive SwiftUI rule.
// Compare against GoodView.swift, which fixes each one.
import SwiftUI

struct BadProfileView: View {
    @State private var email = ""
    @State private var syncFailed = false

    var body: some View {
        VStack(spacing: 16) {
            // swiftui/image-no-label (WCAG 1.1.1) — informative image, no accessible name
            Image("profileBanner")
                .resizable()
                .frame(height: 120)

            // swiftui/control-no-name (WCAG 4.1.2) — icon-only button, no accessible name
            Button(action: share) {
                Image("shareIcon")
            }

            // swiftui/field-no-label (WCAG 1.3.1 / 4.1.2) — text field with no label
            TextField("", text: $email)
                .textFieldStyle(.roundedBorder)

            // swiftui/color-only-state (WCAG 1.4.1) — state conveyed by color alone
            Text("Sync status")
                .foregroundColor(syncFailed ? .red : .green)
        }
        .padding()
    }

    func share() {}
}
