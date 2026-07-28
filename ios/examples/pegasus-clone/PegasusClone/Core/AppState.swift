import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var tripType: TripType = .roundTrip
    @Published var origin: Airport?
    @Published var destination: Airport?
    @Published var departureDate: Date?
    @Published var returnDate: Date?
    @Published var passengers = PassengerCounts()
    @Published var selectedTab = 0

    // sheet routing
    @Published var showRouteSheet = false
    @Published var routeSheetFocus: RouteField = .origin
    @Published var showDateSheet = false
    @Published var dateSheetFocus: DateField = .departure
    @Published var showPassengerSheet = false
    @Published var showResults = false

    var originText: String { origin?.display ?? "Nereden?" }
    var destinationText: String { destination?.display ?? "Nereye?" }

    var departureText: String {
        departureDate.map(TurkishCalendar.compact) ?? "Gidiş Tarihi"
    }

    var returnText: String {
        guard tripType == .roundTrip else { return "Tek yön" }
        return returnDate.map(TurkishCalendar.compact) ?? "Dönüş Tarihi"
    }

    var canSearch: Bool { origin != nil && destination != nil && departureDate != nil }

    func swapRoute() {
        let old = origin
        origin = destination
        destination = old
    }

    func count(for kind: PassengerKind) -> Int {
        switch kind {
        case .adult:   return passengers.adults
        case .child:   return passengers.children
        case .infant:  return passengers.infants
        }
    }

    func setCount(_ value: Int, for kind: PassengerKind) {
        let clamped = max(minimum(for: kind), min(maximum(for: kind), value))
        switch kind {
        case .adult:   passengers.adults = clamped
        case .child:   passengers.children = clamped
        case .infant:  passengers.infants = clamped
        }
    }

    func minimum(for kind: PassengerKind) -> Int { kind == .adult ? 1 : 0 }
    func maximum(for kind: PassengerKind) -> Int { kind == .infant ? passengers.adults : 9 }

    func canIncrement(_ kind: PassengerKind) -> Bool { count(for: kind) < maximum(for: kind) }
    func canDecrement(_ kind: PassengerKind) -> Bool { count(for: kind) > minimum(for: kind) }

    func openRouteSheet(_ field: RouteField) {
        routeSheetFocus = field
        showRouteSheet = true
    }

    func openDateSheet(_ field: DateField) {
        dateSheetFocus = field
        showDateSheet = true
    }

    func select(_ airport: Airport) {
        switch routeSheetFocus {
        case .origin:
            origin = airport
            if destination == nil { routeSheetFocus = .destination } else { showRouteSheet = false }
        case .destination:
            destination = airport
            showRouteSheet = false
        }
    }

    func selectDate(_ date: Date) {
        switch dateSheetFocus {
        case .departure:
            departureDate = date
            if let ret = returnDate, ret < date { returnDate = nil }
            if tripType == .roundTrip { dateSheetFocus = .arrival }
        case .arrival:
            if let dep = departureDate, date < dep {
                departureDate = date
                returnDate = nil
            } else {
                returnDate = date
            }
        }
    }

    var resultFlights: [Flight] {
        SampleData.flights(from: origin?.id ?? "ESB", to: destination?.id ?? "SAW")
    }
}
