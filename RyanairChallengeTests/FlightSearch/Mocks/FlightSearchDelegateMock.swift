//
//  FlightSearchDelegateMock.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
@testable import RyanairChallenge

class FlightSearchDelegateMock: FlightSearchDelegate {

    var didSelectOrigin = false
    var didSelectDestination = false
    var didSelectDepartureDate = false
    var didSelectReturnDate = false
    var didSelectPax = false

    func didSelectOrigin(station: Station) {
        didSelectOrigin = true
    }

    func didSelectDestination(station: Station) {
        didSelectDestination = true
    }

    func didSelectDepartureDate(departureDate: Date) {
        didSelectDepartureDate = true
    }

    func didSelectReturnDate(returnDate: Date) {
        didSelectReturnDate = true
    }

    func didSelectPax(passengerCount: PassengerCount) {
        didSelectPax = true
    }
}
