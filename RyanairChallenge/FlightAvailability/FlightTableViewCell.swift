//
//  FlightTableViewCell.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 14/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

class FlightTableViewCell: UITableViewCell {

    @IBOutlet weak var fareContainer: UIStackView!
    @IBOutlet weak var adultFareContainer: UIStackView!
    @IBOutlet weak var adultFareValue: UILabel!
    @IBOutlet weak var teenFareContainer: UIStackView!
    @IBOutlet weak var teenFareValue: UILabel!
    @IBOutlet weak var childrenFareContainer: UIStackView!
    @IBOutlet weak var childrenFareValue: UILabel!

    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var flightDate: UILabel!

    func initView(flight: Flight) {
        fillFares(flight)
        flightNumber.text = flight.number
        flightDate.text = flight.flightDate()
    }

    private func fillFares(_ flight: Flight) {
        if !flight.fares.isEmpty {
            fillFareOrHideContainer(publishedFare: flight.getAdultFare(), value: adultFareValue, container: adultFareContainer)
            fillFareOrHideContainer(publishedFare: flight.getTeenFare(), value: teenFareValue, container: teenFareContainer)
            fillFareOrHideContainer(publishedFare: flight.getChildrenFare(), value: childrenFareValue, container: childrenFareContainer)
        } else {
            fareContainer.isHidden = true
        }
    }

    private func fillFareOrHideContainer(publishedFare: Double?, value: UILabel, container: UIStackView) {
        if let fare = publishedFare {
            value.text = "$\(fare)"
        } else {
            container.isHidden = true
        }
    }
}
