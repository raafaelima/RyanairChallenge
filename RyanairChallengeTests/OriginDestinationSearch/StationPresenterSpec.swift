//
//  StationPresenterSpec.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import RyanairChallenge

class StationPresenterSpec: QuickSpec {

    var delegateMock = StationsDelegateMock()

    override func spec() {
        describe("The Station Presenter") {

            it("should return a list of Stations") {
                var presenter = StationPresenter(api: FlightsAPIMock())
                presenter.delegate = self.delegateMock
                presenter.loadStationsFromServer()
                expect(self.delegateMock.didCallLoadStationsIntoList).to(beTrue())
            }

            it("should call the error indicator when has error on get data") {
                let failedAPI = FlightsAPIMock()
                failedAPI.error = true

                var presenter = StationPresenter(api: failedAPI)
                presenter.delegate = self.delegateMock

                presenter.loadStationsFromServer()

                expect(self.delegateMock.didCallErrorAtLoadingStations).to(beTrue())
            }
            it("should call the error indicator when station list is empty") {
                let failedAPI = FlightsAPIMock()
                failedAPI.emptyResponse = true

                var presenter = StationPresenter(api: failedAPI)
                presenter.delegate = self.delegateMock

                presenter.loadStationsFromServer()

                expect(self.delegateMock.didCallErrorAtLoadingStations).to(beTrue())
            }
        }
    }
}
