//
//  FlightAvailabilityViewControllerSpec.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import RyanairChallenge

class FlightAvailabilityViewControllerSpec: QuickSpec {

    override func spec() {

        var view: FlightAvailabilityViewController?
        let tripList = JSONHelper.getObjectFrom(json: "trips", type: TripList.self)

        beforeEach {

            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let masterViewController = storyBoard.instantiateViewController(withIdentifier: "flightAvailabilityVC") as! FlightAvailabilityViewController

            let navigationController = UINavigationController()
            navigationController.viewControllers.append(masterViewController)
            view = masterViewController

            _ = view?.view
            view?.flightSearchData = self.buildDummyFlightData()
            view?.flightDataSource = tripList!.trips!.first!.flights!
            view?.viewDidLoad()
        }

        describe("ViewDidLoad") {
            it("should load the presenter") {
                expect(view?.presenter).toNot(beNil())
            }
        }

        describe("loadTripListInfo") {

            it("should have the correct title") {
                view?.loadTripListInfo((tripList?.trips)!)
                expect(view?.navigationItem.title).toEventually(equal("OPO -> BCN"))
            }

            it("should load the dataSource when call view method") {
                view?.loadTripListInfo((tripList?.trips)!)
                expect(view?.flightDataSource.count).toEventually(equal(3))
            }
        }

        describe("TableView") {

            it("should return the right number of rows") {
                expect(view?.tableView.numberOfRows(inSection: 0)).to(equal(3))
            }

            it("should return the right number of sections") {
                expect(view?.tableView.numberOfSections).to(equal(1))
            }

            it("should return FR 4584 if user select first Cell") {
                let indexPath = IndexPath(row: 0, section: 0)
                view?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                let cell = view?.tableView.cellForRow(at: indexPath) as! FlightTableViewCell

                expect(cell.flightNumber.text).to(equal("FR 4584"))
                expect(cell.flightDate.text).to(equal("17/08/2020"))
                expect(cell.adultFareValue.text).to(equal("$98.99"))

                expect(cell.teenFareValue.isHidden).to(beFalse())
                expect(cell.adultFareContainer.isHidden).to(beFalse())
                expect(cell.childrenFareValue.isHidden).to(beFalse())
            }
        }
    }

    private func buildDummyFlightData() -> FlightSearchData {
        let dummyStation = Station(code: "", name: "", countryName: "")
        let dummyPax = PassengerCount(adults: 1, teen: 0, children: 0)
        return FlightSearchData(origin: dummyStation, destination: dummyStation, departureDate: Date(), paxCount: dummyPax)
    }
}
