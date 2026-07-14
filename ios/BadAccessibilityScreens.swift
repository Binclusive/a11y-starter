// KNOWN-BAD fixtures for testing the GitHub a11y action on iOS.
// Each screen demonstrates one common SwiftUI accessibility violation.
import SwiftUI

struct BadPromoImageScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Summer launch")
                .font(.title)

            // VIOLATION 1: Informative image has no accessible label.
            // Expected finding: swiftui/image-no-label.
            Image("summerPromo")
                .resizable()
                .scaledToFit()
                .frame(height: 180)
        }
        .padding()
    }
}

struct BadIconOnlyActionScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Receipt")
                .font(.title)

            // VIOLATION 2: Icon-only control has no accessible name.
            // Expected finding: swiftui/control-no-name.
            Button(action: downloadReceipt) {
                Image(systemName: "arrow.down.doc")
            }
        }
        .padding()
    }

    private func downloadReceipt() {}
}

struct BadCheckoutFormScreen: View {
    @State private var fullName = ""
    @State private var cardNumber = ""

    var body: some View {
        Form {
            Section {
                // VIOLATION 3: Form fields have empty labels.
                // Expected finding: swiftui/field-no-label.
                TextField("", text: $fullName)
                    .textContentType(.name)

                TextField("", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .textContentType(.creditCardNumber)
            }
        }
    }
}

struct BadOrderStatusScreen: View {
    @State private var isDelayed = true

    var body: some View {
        VStack(spacing: 16) {
            Text("Order status")
                .font(.title)

            // VIOLATION 4: State is communicated by color alone.
            // Expected finding: swiftui/color-only-state.
            Text("Delivery")
                .foregroundColor(isDelayed ? .red : .green)
        }
        .padding()
    }
}

struct BadTappableTextScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Saved address")
                .font(.title)

            // VIOLATION 5: A non-control view is made interactive without a
            // button role or accessible action name.
            Text("Change")
                .foregroundColor(.blue)
                .onTapGesture(perform: changeAddress)
        }
        .padding()
    }

    private func changeAddress() {}
}
