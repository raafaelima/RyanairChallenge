//
//  StationsTableViewControllerMock.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
@testable import RyanairChallenge

class StationsDelegateMock: StationsDelegate {

    var didCallLoadStationsIntoList = false
    var didCallErrorAtLoadingStations = false

    func loadStationsIntoList(stations: [Station]) {
        didCallLoadStationsIntoList = true
    }

    func showErrorAtLoadingStations() {
        didCallErrorAtLoadingStations = true
    }
}
