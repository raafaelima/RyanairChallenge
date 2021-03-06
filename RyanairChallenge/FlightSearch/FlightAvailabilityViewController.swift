//
//  FlightAvailabilityViewController.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

protocol FlightAvailabilityResultDelegate: class {
    func didSelectOrigin(station: Station)
    func didSelectDestination(station: Station)
    func didSelectDepartureDate(departureDate: Date)
    func didSelectReturnDate(returnDate: Date)
    func didSelectPax(passengerCount: PassengerCount)
}

enum FlightAvailabilitySegueIdentifier: String {
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

    var selectedOriginStation: Station?
    var selectedDestinationStation: Station?
    var selectedReturnDate: Date?
    var selectedDepartureDate: Date?
    var selectedPassengerCount = PassengerCount(adults: 1, teen: 0, children: 0)

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == FlightAvailabilitySegueIdentifier.origin.rawValue {
            if let stationsVC = segue.destination as? StationsTableViewController {
                stationsVC.delegate = self
                stationsVC.searchType = .origin
            }
        }

        if segue.identifier == FlightAvailabilitySegueIdentifier.destination.rawValue {
            if let stationsVC = segue.destination as? StationsTableViewController {
                stationsVC.delegate = self
                stationsVC.searchType = .destination
            }
        }

        if segue.identifier == FlightAvailabilitySegueIdentifier.showDeparture.rawValue {
            if let departureAndArrivalDatesVC = segue.destination as? DepartureAndArrivalDateViewController {
                departureAndArrivalDatesVC.delegate = self
                departureAndArrivalDatesVC.dateCalendarSelectionType = .departureDate
                departureAndArrivalDatesVC.selectedDate = selectedDepartureDate
            }
        }

        if segue.identifier == FlightAvailabilitySegueIdentifier.showReturn.rawValue {
            if let departureAndArrivalDatesVC = segue.destination as? DepartureAndArrivalDateViewController {
                departureAndArrivalDatesVC.delegate = self
                departureAndArrivalDatesVC.dateCalendarSelectionType = .returnDate
                departureAndArrivalDatesVC.selectedDate = selectedReturnDate
            }
        }

        if segue.identifier == FlightAvailabilitySegueIdentifier.paxDetails.rawValue {
            if let paxDetailsVC = segue.destination as? PaxDetailsViewController {
                paxDetailsVC.delegate = self
                paxDetailsVC.totalAdults = selectedPassengerCount.adults
                paxDetailsVC.totalTeen = selectedPassengerCount.teen
                paxDetailsVC.totalChildren = selectedPassengerCount.children
            }
        }
    }
}

extension FlightSearchViewController: FlightAvailabilityResultDelegate {

    // MARK: - CallBacks
    func didSelectOrigin(station: Station) {
        self.selectedOriginStation = station
        setSelectedState(view: self.originAirport, label: station.toLabel())
    }

    func didSelectDestination(station: Station) {
        self.selectedDestinationStation = station
        setSelectedState(view: self.destinationAirport, label: station.toLabel())
    }

    func didSelectDepartureDate(departureDate: Date) {
        self.selectedDepartureDate = departureDate

        if isDepartureDateAfterReturn() {
            clearDates()
        } else {
            setSelectedState(view: self.departureDate, label: formatDate(date: departureDate))
        }
    }

    func didSelectReturnDate(returnDate: Date) {
        self.selectedReturnDate = returnDate

        if isReturnDateAfterDeparture() {
            clearDates()
        } else {
            setSelectedState(view: self.returnDate, label: formatDate(date: returnDate))
        }
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
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: date)
    }

    private func isDepartureDateAfterReturn () -> Bool {
        if let _selectedReturnDate = selectedReturnDate, let _selectedDepartureDate = selectedDepartureDate {
            return _selectedDepartureDate > _selectedReturnDate
        }
        return false
    }

    private func isReturnDateAfterDeparture () -> Bool {
        if let _selectedReturnDate = selectedReturnDate, let _selectedDepartureDate = selectedDepartureDate {
            return _selectedReturnDate < _selectedDepartureDate
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
