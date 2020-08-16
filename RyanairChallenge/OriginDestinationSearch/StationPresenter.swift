//
//  StationPresenter.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

struct StationPresenter {

    private var api: FlightAPIType
    weak var delegate: StationsDelegate?

    init(api: FlightAPIType = FlightAPI()) {
        self.api = api
    }

    func loadStationsFromServer() {
        api.getStations { result in
            switch result {
            case .success(let stationList):
                if let stations = stationList.stations, !stations.isEmpty {
                    self.delegate?.loadStationsIntoList(stations: stations)
                } else {
                    self.delegate?.showErrorAtLoadingStations()
                }
            case .failure:
                self.delegate?.showErrorAtLoadingStations()
            }
        }
    }
}
