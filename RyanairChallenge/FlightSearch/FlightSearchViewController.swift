//
//  FlightAvailabilityViewController.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

protocol FlightSearchDelegate: class {
    func didSelectOrigin(station: Station)
    func didSelectDestination(station: Station)
    func didSelectDepartureDate(departureDate: Date)
    func didSelectReturnDate(returnDate: Date)
    func didSelectPax(passengerCount: PassengerCount)
}

enum FlightSearchSegueIdentifier: String {
    case origin
    case destination
    case paxDetails
    case showDeparture
    case showReturn
    case searchFlights
}

class FlightSearchViewController: UIViewController {

    @IBOutlet weak var originAirport: UIButton!
    @IBOutlet weak var destinationAirport: UIButton!
    @IBOutlet weak var paxDetails: UIButton!
    @IBOutlet weak var departureDate: UIButton!
    @IBOutlet weak var returnDate: UIButton!
    @IBOutlet weak var searchButton: UIButton!

    var selectedOriginStation: Station?
    var selectedDestinationStation: Station?
    var selectedReturnDate: Date?
    var selectedDepartureDate: Date?
    var searchFlightData: FlightSearchData!
    var selectedPassengerCount = PassengerCount(adults: 1, teen: 0, children: 0)

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enableDisableSearch()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == FlightSearchSegueIdentifier.origin.rawValue {
            if let stationsVC = segue.destination as? StationsTableViewController {
                stationsVC.delegate = self
                stationsVC.searchType = .origin
            }
        }

        if segue.identifier == FlightSearchSegueIdentifier.destination.rawValue {
            if let stationsVC = segue.destination as? StationsTableViewController {
                stationsVC.delegate = self
                stationsVC.searchType = .destination
            }
        }

        if segue.identifier == FlightSearchSegueIdentifier.showDeparture.rawValue {
            if let departureAndArrivalDatesVC = segue.destination as? DepartureAndArrivalDateViewController {
                departureAndArrivalDatesVC.delegate = self
                departureAndArrivalDatesVC.dateCalendarSelectionType = .departureDate
                departureAndArrivalDatesVC.selectedDate = selectedDepartureDate
            }
        }

        if segue.identifier == FlightSearchSegueIdentifier.showReturn.rawValue {
            if let departureAndArrivalDatesVC = segue.destination as? DepartureAndArrivalDateViewController {
                departureAndArrivalDatesVC.delegate = self
                departureAndArrivalDatesVC.dateCalendarSelectionType = .returnDate
                departureAndArrivalDatesVC.selectedDate = selectedReturnDate
            }
        }

        if segue.identifier == FlightSearchSegueIdentifier.paxDetails.rawValue {
            if let paxDetailsVC = segue.destination as? PaxDetailsViewController {
                paxDetailsVC.delegate = self
                paxDetailsVC.totalAdults = selectedPassengerCount.adults
                paxDetailsVC.totalTeen = selectedPassengerCount.teen
                paxDetailsVC.totalChildren = selectedPassengerCount.children
            }
        }

        if segue.identifier == FlightSearchSegueIdentifier.searchFlights.rawValue {
            if let flightAvailabilityVC = segue.destination as? FlightAvailabilityViewController {
                self.searchFlightData = FlightSearchData(origin: selectedOriginStation!,
                                                         destination: selectedDestinationStation!,
                                                         departureDate: selectedDepartureDate!,
                                                         paxCount: selectedPassengerCount)

                flightAvailabilityVC.flightSearchData = searchFlightData
            }
        }
    }
}

extension FlightSearchViewController: FlightSearchDelegate {

    // MARK: - CallBacks
    func didSelectOrigin(station: Station) {
        self.selectedOriginStation = station
        setSelectedState(view: self.originAirport, label: station.toLabel())
        enableDisableSearch()
    }

    func didSelectDestination(station: Station) {
        self.selectedDestinationStation = station
        setSelectedState(view: self.destinationAirport, label: station.toLabel())
        enableDisableSearch()
    }

    func didSelectDepartureDate(departureDate: Date) {
        self.selectedDepartureDate = departureDate

        if isDepartureDateAfterReturn() {
            clearDates()
        } else {
            setSelectedState(view: self.departureDate, label: formatDate(date: departureDate))
        }

        enableDisableSearch()
    }

    func didSelectReturnDate(returnDate: Date) {
        self.selectedReturnDate = returnDate

        if isReturnDateAfterDeparture() {
            clearDates()
        } else {
            setSelectedState(view: self.returnDate, label: formatDate(date: returnDate))
        }

        enableDisableSearch()
    }

    func didSelectPax(passengerCount: PassengerCount) {
        self.selectedPassengerCount = passengerCount
        var paxMessage: String

        if passengerCount.hasTeenOrChildren() {
            paxMessage = "\(passengerCount.totalPax()) Passengers"
        } else {
            paxMessage = "\(passengerCount.adults) Adult"
        }

        setSelectedState(view: paxDetails, label: paxMessage)
    }

    // MARK: - Aux Methods
    private func enableDisableSearch() {
        if requiredDataFilled() {
            self.searchButton.isEnabled = true
            self.searchButton.backgroundColor = UIColor.link
        } else {
            self.searchButton.isEnabled = false
            self.searchButton.backgroundColor = UIColor.lightGray
        }
    }

    private func requiredDataFilled() -> Bool {
        return selectedOriginStation != nil
            && selectedDestinationStation != nil
            && selectedDepartureDate?.timeIntervalSinceReferenceDate != nil
            && selectedPassengerCount.adults >= 1
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: date)
    }

    private func isDepartureDateAfterReturn () -> Bool {
        if let _selectedReturnDate = selectedReturnDate, let _selectedDepartureDate = selectedDepartureDate {
            return _selectedDepartureDate >= _selectedReturnDate
        }
        return false
    }

    private func isReturnDateAfterDeparture () -> Bool {
        if let _selectedReturnDate = selectedReturnDate, let _selectedDepartureDate = selectedDepartureDate {
            return _selectedReturnDate <= _selectedDepartureDate
        }
        return false
    }

    private func setSelectedState(view: UIButton, label: String) {
        view.setTitle(label, for: .normal)
        view.setTitleColor(UIColor.blue, for: .normal)
    }

    private func clearDates() {
        self.selectedReturnDate = nil
        self.selectedDepartureDate = nil

        returnDate.setTitle("MM/DD/YYYY", for: .normal)
        departureDate.setTitle("MM/DD/YYYY", for: .normal)

        returnDate.setTitleColor(UIColor.gray, for: .normal)
        departureDate.setTitleColor(UIColor.gray, for: .normal)
    }
}
