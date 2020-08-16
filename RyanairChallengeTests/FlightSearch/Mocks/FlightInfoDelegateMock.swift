//
//  FlightInfoDelegateMock.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
@testable import RyanairChallenge

class FlightInfoDelegateMock: FlightInfoDelegate {

    var didCallLoadTripListInfo = false
    var didCallShowErrorAtLoadingTripList = false

    func loadTripListInfo(_ trips: [Trip]) {
        didCallLoadTripListInfo = true
    }

    func showErrorAtLoadingTripList() {
        didCallShowErrorAtLoadingTripList = true
    }
}
