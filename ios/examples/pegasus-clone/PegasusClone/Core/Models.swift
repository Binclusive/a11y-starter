import Foundation

struct Airport: Identifiable, Hashable {
    let id: String          // IATA-ish code
    let city: String
    let country: String

    var display: String { city }
}

enum TripType: String, CaseIterable, Identifiable {
    case roundTrip
    case oneWay

    var id: String { rawValue }

    var title: String {
        switch self {
        case .roundTrip: return "Gidiş Dönüş"
        case .oneWay:    return "Tek Yön"
        }
    }
}

enum RouteField {
    case origin, destination

    var title: String {
        switch self {
        case .origin:      return "Nereden?"
        case .destination: return "Nereye?"
        }
    }
}

enum DateField {
    case departure, arrival

    var title: String {
        switch self {
        case .departure: return "Gidiş Tarihi"
        case .arrival:   return "Dönüş Tarihi"
        }
    }
}

struct PassengerCounts: Equatable {
    var adults = 1
    var children = 0
    var infants = 0
    var students = 0

    var total: Int { adults + children + infants + students }

    var summary: String {
        var parts: [String] = []
        if adults > 0 { parts.append("\(adults) Yetişkin") }
        if children > 0 { parts.append("\(children) Çocuk") }
        if infants > 0 { parts.append("\(infants) Bebek") }
        if students > 0 { parts.append("\(students) Öğrenci") }
        return parts.isEmpty ? "Yolcu seçiniz" : parts.joined(separator: ", ")
    }
}

enum PassengerKind: String, CaseIterable, Identifiable {
    case adult, child, infant, student

    var id: String { rawValue }

    var title: String {
        switch self {
        case .adult:   return "Yetişkin"
        case .child:   return "Çocuk"
        case .infant:  return "Bebek"
        case .student: return "Öğrenci"
        }
    }

    var subtitle: String {
        switch self {
        case .adult:   return "12 yaş ve üzeri"
        case .child:   return "2 - 12 yaş arası"
        case .infant:  return "0 - 2 yaş arası"
        case .student: return "12 yaş ve üzeri öğrenci"
        }
    }
}

struct Flight: Identifiable {
    let id = UUID()
    let originCode: String
    let destinationCode: String
    let departure: String
    let arrival: String
    let duration: String
    let price: Double
    let isCheapest: Bool
    let connection: String?   // nil == direct
    let layover: String?
    let soldOut: Bool
}

struct RecentSearch: Identifiable {
    let id = UUID()
    let origin: String
    let destination: String
    let dateText: String
    let passengerText: String
}

enum SampleData {
    static let recentAirports: [Airport] = [
        Airport(id: "ESB", city: "Ankara", country: "Türkiye"),
        Airport(id: "SAW", city: "İstanbul Sabiha Gökçen", country: "Türkiye"),
        Airport(id: "IST", city: "İstanbul Tümü", country: "Türkiye"),
        Airport(id: "VAS", city: "Sivas", country: "Türkiye")
    ]

    static let allAirports: [Airport] = [
        Airport(id: "AAL", city: "Aalborg", country: "Danimarka"),
        Airport(id: "AAR", city: "Aarhus", country: "Danimarka"),
        Airport(id: "AUH", city: "Abudhabi", country: "Birleşik Arap Emirlikleri"),
        Airport(id: "ADF", city: "Adıyaman", country: "Türkiye"),
        Airport(id: "AJI", city: "Ağrı", country: "Türkiye"),
        Airport(id: "GRV", city: "Airport Grozny im. A.A. Kadyro", country: "Rusya Federasyonu"),
        Airport(id: "SCO", city: "Aktau", country: "Kazakistan"),
        Airport(id: "AMM", city: "Amman", country: "Ürdün"),
        Airport(id: "AMS", city: "Amsterdam", country: "Hollanda"),
        Airport(id: "ESB", city: "Ankara", country: "Türkiye"),
        Airport(id: "AYT", city: "Antalya", country: "Türkiye"),
        Airport(id: "BGW", city: "Bağdat", country: "Irak"),
        Airport(id: "BAH", city: "Bahreyn", country: "Bahreyn"),
        Airport(id: "BSR", city: "Basra", country: "Irak"),
        Airport(id: "BER", city: "Berlin", country: "Almanya"),
        Airport(id: "BEY", city: "Beyrut", country: "Lübnan"),
        Airport(id: "DMM", city: "Dammam", country: "Suudi Arabistan"),
        Airport(id: "DOH", city: "Doha", country: "Katar"),
        Airport(id: "DXB", city: "Dubai", country: "Birleşik Arap Emirlikleri"),
        Airport(id: "EBL", city: "Erbil", country: "Irak"),
        Airport(id: "IST", city: "İstanbul Tümü", country: "Türkiye"),
        Airport(id: "SAW", city: "İstanbul Sabiha Gökçen", country: "Türkiye"),
        Airport(id: "ADB", city: "İzmir", country: "Türkiye"),
        Airport(id: "KWI", city: "Kuveyt", country: "Kuveyt"),
        Airport(id: "LGW", city: "Londra Gatwick", country: "İngiltere"),
        Airport(id: "CDG", city: "Paris Charles de Gaulle", country: "Fransa"),
        Airport(id: "SHJ", city: "Şarjah", country: "Birleşik Arap Emirlikleri"),
        Airport(id: "VAS", city: "Sivas", country: "Türkiye"),
        Airport(id: "TZX", city: "Trabzon", country: "Türkiye")
    ]

    static let recentSearches: [RecentSearch] = [
        RecentSearch(origin: "Ankara", destination: "İstanbul Tümü", dateText: "30 Eyl 2026", passengerText: "1 Yolcu"),
        RecentSearch(origin: "İstanbul Tümü", destination: "Sivas", dateText: "24 Eyl 2026", passengerText: "1 Yolcu")
    ]

    static let middleEastDestinations = [
        "ABU DABİ", "AMMAN", "BAĞDAT",
        "BAHREYN", "BASRA", "BEYRUT",
        "DAMMAM", "DOHA", "DUBAİ",
        "ERBİL", "KUVEYT", "ŞARJAH"
    ]

    static func flights(from origin: String, to destination: String) -> [Flight] {
        [
            Flight(originCode: origin, destinationCode: destination,
                   departure: "13:15", arrival: "17:35", duration: "3sa 20dk",
                   price: 11511, isCheapest: false, connection: nil, layover: nil, soldOut: false),
            Flight(originCode: origin, destinationCode: destination,
                   departure: "17:30", arrival: "21:50", duration: "3sa 20dk",
                   price: 9844, isCheapest: true, connection: nil, layover: nil, soldOut: false),
            Flight(originCode: origin, destinationCode: destination,
                   departure: "19:15", arrival: "08:20", duration: "12sa 5dk",
                   price: 12360, isCheapest: false, connection: "AYT Aktarmalı", layover: "Aktarma Süresi: 7 sa", soldOut: true)
        ]
    }

    /// Deterministic fake fare for a calendar day, so prices are stable across runs.
    static func fare(for date: Date) -> Double? {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        if date < Calendar.current.startOfDay(for: Date()) { return nil }
        let base = 3_900 + Double((day * 977) % 9_500)
        return (base / 10).rounded() * 10
    }
}

enum TurkishCalendar {
    static let monthNames = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
                             "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    static let shortWeekdays = ["Pt", "Sa", "Ça", "Pe", "Cu", "Ct", "Pa"]
    static let longWeekdays = ["Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi", "Pazar"]
    static let shortMonths = ["Oca", "Şub", "Mar", "Nis", "May", "Haz",
                              "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"]

    static var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2 // Monday
        return cal
    }

    static func monthTitle(_ date: Date) -> String {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return "\(monthNames[(comps.month ?? 1) - 1]) \(comps.year ?? 2026)"
    }

    /// "31 Tem, Cum"
    static func shortLabel(_ date: Date) -> String {
        let c = calendar.dateComponents([.day, .month, .weekday], from: date)
        let weekdayIndex = ((c.weekday ?? 1) + 5) % 7  // Sunday==1 -> 6
        let short = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"][weekdayIndex]
        return "\(c.day ?? 1) \(shortMonths[(c.month ?? 1) - 1]), \(short)"
    }

    /// "31 Temmuz 2026 Cuma" — the spelled-out form VoiceOver should hear.
    static func spokenLabel(_ date: Date) -> String {
        let c = calendar.dateComponents([.day, .month, .year, .weekday], from: date)
        let weekdayIndex = ((c.weekday ?? 1) + 5) % 7
        return "\(c.day ?? 1) \(monthNames[(c.month ?? 1) - 1]) \(c.year ?? 2026) \(longWeekdays[weekdayIndex])"
    }

    /// "30 Eyl 2026"
    static func compact(_ date: Date) -> String {
        let c = calendar.dateComponents([.day, .month, .year], from: date)
        return "\(c.day ?? 1) \(shortMonths[(c.month ?? 1) - 1]) \(c.year ?? 2026)"
    }

    static func days(inMonthOf date: Date) -> [Date?] {
        let cal = calendar
        guard let interval = cal.dateInterval(of: .month, for: date) else { return [] }
        let first = interval.start
        let count = cal.range(of: .day, in: .month, for: first)?.count ?? 30
        let weekday = cal.component(.weekday, from: first)
        let leading = ((weekday + 5) % 7)
        var cells: [Date?] = Array(repeating: nil, count: leading)
        for offset in 0..<count {
            cells.append(cal.date(byAdding: .day, value: offset, to: first))
        }
        return cells
    }

    static func months(from start: Date, count: Int) -> [Date] {
        let cal = calendar
        let base = cal.date(from: cal.dateComponents([.year, .month], from: start)) ?? start
        return (0..<count).compactMap { cal.date(byAdding: .month, value: $0, to: base) }
    }
}

enum Money {
    static func tl(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }

    static func tlWithDecimals(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    /// VoiceOver should hear "9.844 Türk lirası", not "9,844".
    static func spoken(_ value: Double) -> String {
        "\(Int(value)) Türk lirası"
    }
}
