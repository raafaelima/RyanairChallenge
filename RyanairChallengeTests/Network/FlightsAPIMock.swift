//
//  FlightsAPIMock.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
@testable import RyanairChallenge

class FlightsAPIMock: FlightAPIType {

    var error: Bool = false
    var emptyResponse = false

    func getStations(completion: @escaping (Result<Stations, Error>) -> Void) {
        let mockStation = Station(code: "", name: "", countryName: "")
        let station = [mockStation, mockStation]
        var stations = Stations(stations: station)

        if emptyResponse {
            stations.stations = []
        }
        error ? completion(.failure(ErrorMock.anError)): completion(.success(stations))
    }

    func searchFlights(_ params: FlightSearchData, completion: @escaping (Result<TripList, Error>) -> Void) {

        var tripList = JSONHelper.getObjectFrom(json: "trips", type: TripList.self)

        if emptyResponse {
            tripList?.trips = []
        }
        error ? completion(.failure(ErrorMock.anError)): completion(.success(tripList!))
    }
}
