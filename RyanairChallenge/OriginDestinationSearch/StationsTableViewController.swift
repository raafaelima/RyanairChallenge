//
//  StationsTableView.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

protocol StationsDelegate: class {
    func loadStationsIntoList(stations: [Station])
    func showErrorAtLoadingStations()
}

enum StationSearchType {
    case origin
    case destination
}

class StationsTableViewController: UITableViewController, StationsDelegate {

    var presenter: StationPresenter!
    private var activityIndicatorView: UIActivityIndicatorView!

    weak var delegate: FlightSearchDelegate?
    var searchType: StationSearchType!

    var stationsDataSource = [Station]()
    var filteredStationsDataSource = [Station]()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter = StationPresenter()
        self.presenter.delegate = self

        self.setupSearchController()
        self.setupActivityIndicator()
        self.presenter.loadStationsFromServer()
        self.tableView.accessibilityIdentifier = "stationsTable"
    }

    func loadStationsIntoList(stations: [Station]) {
        OperationQueue.main.addOperation({
            self.stationsDataSource = stations
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
            self.activityIndicatorView.stopAnimating()
        })
    }

    func showErrorAtLoadingStations() {
        OperationQueue.main.addOperation({
            self.activityIndicatorView.stopAnimating()
            let alert = UIAlertController(title: "Oh! That's unexpected", message: "Something goes wrong with our servers...Sorry about that :(", preferredStyle: .alert)
            self.present(alert, animated: true)
        })
    }

    private func setupActivityIndicator() {
        self.activityIndicatorView = UIActivityIndicatorView(style: .medium)
        self.tableView.backgroundView = self.activityIndicatorView
        self.tableView.separatorStyle = .none
        self.activityIndicatorView.startAnimating()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Airports"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

// MARK: - TableView Interactions
extension StationsTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredStationsDataSource.count : stationsDataSource.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let stationItem = isFiltering() ? filteredStationsDataSource[indexPath.row] : stationsDataSource[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell
        cell.initView(station: stationItem)
        cell.accessibilityIdentifier = "stationCell#\(indexPath.row)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = isFiltering() ? filteredStationsDataSource[indexPath.row] : stationsDataSource[indexPath.row]

        if searchType == StationSearchType.origin {
            self.delegate?.didSelectOrigin(station: station)
        } else {
            self.delegate?.didSelectDestination(station: station)
        }

        _ = self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - SearchBar Interactions
extension StationsTableViewController: UISearchResultsUpdating {

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStationsDataSource = (stationsDataSource.filter({(station: Station) -> Bool in
            return (station.name.lowercased().contains(searchText.lowercased()))
                || (station.code.lowercased().contains(searchText.lowercased()))
                || (station.countryName.lowercased().contains(searchText.lowercased()))
        }))

        tableView.reloadData()
    }
}
