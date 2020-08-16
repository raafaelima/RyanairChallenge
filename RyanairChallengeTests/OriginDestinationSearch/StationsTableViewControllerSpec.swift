//
//  StationsTableViewControllerSpec.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import RyanairChallenge

class StationsTableViewControllerSpec: QuickSpec {

    override func spec() {

        var view: StationsTableViewController?
        let delegate = FlightSearchDelegateMock()
        let stations = JSONHelper.getObjectFrom(json: "stations", type: Stations.self)

        beforeEach {

            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let masterViewController = storyBoard.instantiateViewController(withIdentifier: "stationsVC") as! StationsTableViewController

            let navigationController = UINavigationController()
            navigationController.viewControllers.append(masterViewController)
            view = masterViewController

            _ = view?.view
            view?.delegate = delegate
            view?.stationsDataSource = (stations?.stations)!
            view?.viewDidLoad()
            view?.tableView.reloadData()
        }

        it("should load the dataSource when call view method") {
            let model = JSONHelper.getObjectFrom(json: "stations", type: Stations.self)
            view?.loadStationsIntoList(stations: (model?.stations)!)
            expect(view?.stationsDataSource.count).to(equal(320))
        }

        describe("ViewDidLoad") {
            it("should load the presenter") {
                expect(view?.presenter).toNot(beNil())
            }

            it("should have the correct title") {
                expect(view?.navigationItem.title).to(equal("Airports"))
            }

            it("should have set the acessible accessibilityIdentifier") {
                expect(view?.tableView.accessibilityIdentifier).to(equal("stationsTable"))
            }

            it("The search bar is in a clean state") {
                expect(view?.isFiltering()).to(beFalse())
                expect(view?.searchBarIsEmpty()).to(beTrue())
                expect(view?.filteredStationsDataSource).to(beEmpty())
            }
        }

        describe("TableView") {

            it("should return the right number of rows") {
                expect(view?.tableView.numberOfRows(inSection: 0)).to(equal(320))
            }

            it("should return the right number of sections") {
                expect(view?.tableView.numberOfSections).to(equal(1))
            }

            it("should return Aalborg if user select first Cell") {
                let indexPath = IndexPath(row: 0, section: 0)
                view?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                let cell = view?.tableView.cellForRow(at: indexPath) as! StationTableViewCell
                expect(cell.cityLabel.text).to(equal("Aalborg"))
                expect(cell.cityCodeLabel.text).to(equal("AAL"))
                expect(cell.countryLabel.text).to(equal("Denmark"))
            }
        }

        describe("UISearchController") {
            it("should present the correct message to the user") {
                view?.viewDidLoad()
                expect(view?.searchController.searchBar.placeholder).to(equal("Search Airports"))
            }

            it("should filter the correct value on list") {
                view?.filterContentForSearchText("Porto")
                expect(view?.filteredStationsDataSource.count).to(equal(1))
                expect(view?.filteredStationsDataSource.first?.name).to(equal("Porto"))
            }
        }
    }
}
