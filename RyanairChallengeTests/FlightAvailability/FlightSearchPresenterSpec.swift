//
//  FlightSearchPresenterSpec.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import RyanairChallenge

class FlightSearchPresenterSpec: QuickSpec {

    var delegateMock = FlightInfoDelegateMock()

    override func spec() {
        describe("The Station Presenter") {

            it("should return a list of Stations") {
                var presenter = FlightSearchPresenter(api: FlightsAPIMock())
                presenter.delegate = self.delegateMock
                presenter.loadFlightsBy(params: self.buildDummyFlightData())
                expect(self.delegateMock.didCallLoadTripListInfo).to(beTrue())

            }

            it("should call the error indicator when has error on get data") {
                let failedAPI = FlightsAPIMock()
                failedAPI.error = true

                var presenter = FlightSearchPresenter(api: failedAPI)
                presenter.delegate = self.delegateMock

                presenter.loadFlightsBy(params: self.buildDummyFlightData())

                expect(self.delegateMock.didCallShowErrorAtLoadingTripList).to(beTrue())
            }
            it("should call the error indicator when station list is empty") {
                let failedAPI = FlightsAPIMock()
                failedAPI.emptyResponse = true

                var presenter = FlightSearchPresenter(api: failedAPI)
                presenter.delegate = self.delegateMock

                presenter.loadFlightsBy(params: self.buildDummyFlightData())

                expect(self.delegateMock.didCallShowErrorAtLoadingTripList).to(beTrue())
            }
        }
    }

    private func buildDummyFlightData() -> FlightSearchData {
        let dummyStation = Station(code: "", name: "", countryName: "")
        let dummyPax = PassengerCount(adults: 1, teen: 0, children: 0)
        return FlightSearchData(origin: dummyStation, destination: dummyStation, departureDate: Date(), paxCount: dummyPax)
    }
}
