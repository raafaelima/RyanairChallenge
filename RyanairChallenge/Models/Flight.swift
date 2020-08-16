//
//  Flight.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 13/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct TripList: Codable {
    var trips: [Trip]?
}

// MARK: - Trip
struct Trip: Codable {
    let origin: String
    let destination: String
    var flights: [Flight]?

    enum CodingKeys: String, CodingKey {
        case origin
        case destination
        case dates
    }

    enum DateCodingKeys: String, CodingKey {
        case flights
    }

    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.origin = try container.decode(String.self, forKey: .origin)
        self.destination = try container.decode(String.self, forKey: .destination)

        var datesContainer = try container.nestedUnkeyedContainer(forKey: .dates)

        while !datesContainer.isAtEnd {
            let flightContainer = try datesContainer.nestedContainer(keyedBy: DateCodingKeys.self)
            self.flights = try flightContainer.decodeIfPresent([Flight].self, forKey: .flights)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(origin, forKey: .origin)
        try container.encode(destination, forKey: .destination)
    }
}

// MARK: - Flight
struct Flight: Codable {

    let number: String
    let duration: String
    let fares: [Fare]
    let departureDate: Date
    let arrivalDate: Date

    enum CodingKeys: String, CodingKey {
        case regularFare
        case number = "flightNumber"
        case duration
        case flightDates = "time"
    }

    enum GroupCodingKeys: String, CodingKey {
        case regularFare
        case fares
    }

    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)
        self.duration = try container.decode(String.self, forKey: .duration)

        let flightDates = try container.decode([Date].self, forKey: .flightDates)
        self.departureDate = flightDates[0]
        self.arrivalDate = flightDates[1]

        let nested = try container.nestedContainer(keyedBy: GroupCodingKeys.self, forKey: .regularFare)
        self.fares = try nested.decode([Fare].self, forKey: .fares)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number, forKey: .number)
        try container.encode(duration, forKey: .duration)
    }

    func hasTeenOrChildrenFareAvailable() -> Bool {
        return self.fares.contains { $0.type == "TEEN" || $0.type == "CHD" }
    }

    func getAdultFare() -> Double? {
        return self.fares.first(where: { $0.type == "ADT" })?.publishedFare
    }

    func getTeenFare() -> Double? {
        return self.fares.first(where: { $0.type == "TEEN" })?.publishedFare
    }

    func getChildrenFare() -> Double? {
        return self.fares.first(where: { $0.type == "CHD" })?.publishedFare
    }

    func flightDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: departureDate)
    }

    func departureHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: departureDate)
    }

    func arrivalHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: arrivalDate)
    }
}

// MARK: - Fare
struct Fare: Codable {
    let type: String
    let publishedFare: Double
}
