//
//  FlightSearchPresenter.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 14/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

struct FlightSearchPresenter {

    private var api: FlightAPIType
    weak var delegate: FlightInfoDelegate?

    init(api: FlightAPIType = FlightAPI()) {
        self.api = api
    }

    func loadFlightsBy(params: FlightSearchData?) {
        if let searchParams = params {
            api.searchFlights(searchParams) { result in
                switch result {
                case .success(let tripList):
                    if let trips = tripList.trips, !trips.isEmpty {
                        self.delegate?.loadTripListInfo(trips)
                    } else {
                        self.delegate?.showErrorAtLoadingTripList()
                    }
                case .failure:
                    self.delegate?.showErrorAtLoadingTripList()
                }
            }
        } else {
            self.delegate?.showErrorAtLoadingTripList()
        }
    }
}
