// CLEAN control — the same screen as BadView.swift, every defect fixed.
// Binclusive reports ZERO findings here.
import SwiftUI

struct GoodProfileView: View {
    @State private var email = ""
    @State private var syncFailed = false

    var body: some View {
        VStack(spacing: 16) {
            // the informative image now carries an accessible name
            Image("profileBanner")
                .resizable()
                .frame(height: 120)
                .accessibilityLabel("Your profile banner")

            // the button is named for its ACTION, not its icon
            Button(action: share) {
                Image("shareIcon")
            }
            .accessibilityLabel("Share profile")

            // the field's naming title argument gives VoiceOver its purpose
            TextField("Email address", text: $email)
                .textFieldStyle(.roundedBorder)

            // state carries a non-color cue (icon + text), so color is redundant
            HStack {
                Image(systemName: syncFailed ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                Text(syncFailed ? "Sync failed" : "Synced")
            }
            .foregroundColor(syncFailed ? .red : .green)
        }
        .padding()
    }

    func share() {}
}
