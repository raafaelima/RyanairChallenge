//
//  FlightSearch.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 13/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

struct FlightSearchData {
    var origin: Station
    var destination: Station
    var departureDate: Date
    var paxCount: PassengerCount

    func formattedDepartureDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: departureDate)
    }
}
