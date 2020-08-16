//
//  PaxDetailsViewController.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

enum DateSelectionType {
    case departureDate
    case returnDate
}

class DepartureAndArrivalDateViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var continueButton: UIButton!

    var minimunDate: Date?
    var selectedDate: Date?
    var dateCalendarSelectionType: DateSelectionType!
    weak var delegate: FlightSearchDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        enableDisableContinueButton()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        enableDisableContinueButton()
    }

    @IBAction func selectDate(_ sender: Any) {

        let selectedDate = calendar.selectedDate

        if dateCalendarSelectionType == .departureDate {
            delegate?.didSelectDepartureDate(departureDate: selectedDate!)
        } else if dateCalendarSelectionType == .returnDate {
            delegate?.didSelectReturnDate(returnDate: selectedDate!)
        }

        _ = self.navigationController?.popViewController(animated: true)
    }

    private func enableDisableContinueButton() {
        if calendar.selectedDate == nil {
            self.continueButton.isEnabled = false
            self.continueButton.backgroundColor = UIColor.lightGray
        } else {
            self.continueButton.isEnabled = true
            self.continueButton.backgroundColor = UIColor.link
        }
    }

    private func setupCalendar() {
        self.calendar.today = nil

        if let date = selectedDate {
            self.calendar.select(date)
        }

        self.calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
        self.calendar.clipsToBounds = true
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        if let minimunDate = self.minimunDate {
            return minimunDate
        } else {
            return Date()
        }
    }
}
