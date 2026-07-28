import SwiftUI

/// Purely visual building blocks. They carry NO accessibility modifiers — the
/// call site decides how (or whether) they reach assistive technology, which in
/// this clone means: mostly not at all.

struct PegasusLogo: View {
    var body: some View {
        Text("PEGASUS")
            .font(.system(size: 22, weight: .heavy, design: .default))
            .italic()
            .foregroundStyle(.white)
            .tracking(-0.5)
    }
}

struct PromoBannerArt: View {
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                Text("YENİDEN BAŞLADIĞIMIZ")
                    .foregroundStyle(Theme.ink)
                Text("ORTA DOĞU UÇUŞLARIMIZ:")
                    .foregroundStyle(Theme.orange)
            }
            .font(.system(size: 26, weight: .black))
            .minimumScaleFactor(0.6)
            .lineLimit(1)

            VStack(spacing: 8) {
                ForEach(Array(stride(from: 0, to: SampleData.middleEastDestinations.count, by: 3)), id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(row..<min(row + 3, SampleData.middleEastDestinations.count), id: \.self) { index in
                            Text(SampleData.middleEastDestinations[index])
                                .font(.system(size: 17, weight: .heavy))
                                .foregroundStyle(Theme.ink)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.white, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            .minimumScaleFactor(0.7)
        }
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(Theme.brandYellow)
    }
}

struct PageDots: View {
    let count: Int
    let index: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<count, id: \.self) { dot in
                Capsule()
                    .fill(dot == index ? Color.white : Color.white.opacity(0.55))
                    .frame(width: dot == index ? 22 : 14, height: 4)
            }
        }
    }
}

struct BolBolLogo: View {
    var body: some View {
        VStack(spacing: -4) {
            Text("BOL")
            Text("BOL")
        }
        .font(.system(size: 13, weight: .black))
        .foregroundStyle(Theme.bolBolRed)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color.orange.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

/// The little map-pin glyph used by the "Nereye Gitsem?" promo row.
struct DestinationPinArt: View {
    var body: some View {
        ZStack {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(Theme.bolBolRed, Theme.brandYellow)
        }
    }
}

struct TabItemArt: View {
    let systemImage: String
    let title: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .regular))
            Text(title)
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
        }
        .foregroundStyle(isSelected ? Theme.brandYellowDeep : Theme.mutedAccessible)
        .frame(maxWidth: .infinity)
    }
}

enum TabDefinition {
    static let items: [(title: String, icon: String)] = [
        ("Ana Sayfa", "house.fill"),
        ("Uçuşlarım", "airplane"),
        ("Check-In", "mappin.and.ellipse"),
        ("Kampanyalar", "megaphone"),
        ("Daha Fazla", "ellipsis")
    ]
}
