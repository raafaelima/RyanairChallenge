//
//  FlightAvailabilityViewController.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 13/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

protocol FlightInfoDelegate: class {
    func loadTripListInfo(_ trips: [Trip])
    func showErrorAtLoadingTripList()
}

class FlightAvailabilityViewController: UITableViewController {

    var presenter: FlightSearchPresenter!
    var flightDataSource = [Flight]()
    private var activityIndicatorView: UIActivityIndicatorView!

    var flightSearchData: FlightSearchData?

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FlightSearchPresenter()
        presenter.delegate = self

        self.setupActivityIndicator()
        presenter.loadFlightsBy(params: flightSearchData)
    }

    func loadFlightsIntoList(_ flights: [Flight]) {
        OperationQueue.main.addOperation({
            self.flightDataSource = flights
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
            self.activityIndicatorView.stopAnimating()
        })
    }

    private func setupActivityIndicator() {
        self.activityIndicatorView = UIActivityIndicatorView(style: .medium)
        self.tableView.backgroundView = self.activityIndicatorView
        self.tableView.separatorStyle = .none
        self.activityIndicatorView.startAnimating()
    }
}

// MARK: - TableView Interactions
extension FlightAvailabilityViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flightDataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flightItem = flightDataSource[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath) as! FlightTableViewCell
        cell.initView(flight: flightItem)
        cell.accessibilityIdentifier = "flightCell#\(indexPath.row)"

        return cell
    }
}

// MARK: - Delegate Interactions
extension FlightAvailabilityViewController: FlightInfoDelegate {

    func loadTripListInfo(_ trips: [Trip]) {

        guard let trip = trips.first else {
            showErrorAtLoadingTripList()
            return
        }

        setTitle(trip)
        loadFlights(trip.flights)
    }

    private func setTitle(_ trip: Trip) {
        OperationQueue.main.addOperation({
            self.navigationController?.navigationBar.topItem?.title = "\(trip.origin) -> \(trip.destination)"
        })
    }

    private func loadFlights(_ flightList: [Flight]?) {
        if let flights = flightList, !flights.isEmpty {
            loadFlightsIntoList(flights)
        } else {
            showEmptyFlightsMessage()
        }
    }

    func showErrorAtLoadingTripList() {
        buildAlert(title: "Oh! That's unexpected", message: "Something goes wrong with our servers...Sorry about that :(")
    }

    private func showEmptyFlightsMessage() {
        buildAlert(title: "Oh, Sorry!", message: "There's no flights available for the selected date")
    }

    private func buildAlert(title: String, message: String) {
        OperationQueue.main.addOperation({
            self.activityIndicatorView.stopAnimating()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Back to Search", style: .default, handler: { _ in
                self.backToSearch()
            }))

            self.present(alert, animated: true)
        })
    }

    private func backToSearch() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
