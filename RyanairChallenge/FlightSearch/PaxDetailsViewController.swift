//
//  PaxDetailsViewController.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 13/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

enum totalPax {
    static let minAdults = 1
    static let maxAdults = 6
    static let minTeen = 0
    static let maxTeen = 6
    static let minChildren = 0
    static let maxChildren = 6
}

class PaxDetailsViewController: UIViewController {

    weak var delegate: FlightSearchDelegate?

    @IBOutlet weak var numberOfAdultsValueLabel: UILabel!
    @IBOutlet weak var numberOfChildrenValueLabel: UILabel!
    @IBOutlet weak var numberOfTeenValueLabel: UILabel!

    @IBOutlet weak var plusAdult: UIButton!
    @IBOutlet weak var minusAdult: UIButton!
    @IBOutlet weak var plusChild: UIButton!
    @IBOutlet weak var minusChild: UIButton!
    @IBOutlet weak var plusTeen: UIButton!
    @IBOutlet weak var minusTeen: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    var totalAdults = totalPax.minAdults
    var totalTeen = totalPax.minTeen
    var totalChildren = totalPax.minChildren

    override func viewDidLoad() {
        super.viewDidLoad()

        numberOfAdultsValueLabel.text = String(totalAdults)
        numberOfChildrenValueLabel.text = String(totalChildren)
        numberOfTeenValueLabel.text = String(totalTeen)

        enableDisableButtons()
    }

    // MARK: - Adult Selection Actions
    @IBAction func OnAdultMinusClick(_ sender: Any) {
        if self.totalAdults > totalPax.minAdults {
            self.totalAdults -= 1
            self.numberOfAdultsValueLabel.text = String(self.totalAdults)
        }
        self.enableDisableButtons()
    }

    @IBAction func onAdultPlusClick(_ sender: Any) {
        if self.totalAdults < (totalPax.maxAdults + 1) {
            self.totalAdults += 1
            self.numberOfAdultsValueLabel.text = String(self.totalAdults)
        }
        self.enableDisableButtons()
    }

    // MARK: - Teen Selection Actions
    @IBAction func onTeenMinusClick(_ sender: Any) {
        if self.totalTeen > totalPax.minTeen {
            self.totalTeen -= 1
            self.numberOfTeenValueLabel.text = String(self.totalTeen)
        }
        self.enableDisableButtons()
    }

    @IBAction func onTeenPlusClick(_ sender: Any) {
        if self.totalTeen < totalPax.maxTeen {
            self.totalTeen += 1
            self.numberOfTeenValueLabel.text = String(self.totalTeen)
        }
        self.enableDisableButtons()
    }

    // MARK: - Children Selection Actions
    @IBAction func onChildrenMinusClick(_ sender: Any) {
        if self.totalChildren > totalPax.minChildren {
            self.totalChildren -= 1
            self.numberOfChildrenValueLabel.text = String(self.totalChildren)
        }
        self.enableDisableButtons()
    }

    @IBAction func onChildrenPlusClick(_ sender: Any) {
        if self.totalChildren < totalPax.maxChildren {
            self.totalChildren += 1
            self.numberOfChildrenValueLabel.text = String(self.totalChildren)
        }
        self.enableDisableButtons()
    }

    @IBAction func done() {
        let paxCount = PassengerCount(adults: totalAdults, teen: totalTeen, children: totalChildren)
        delegate?.didSelectPax(passengerCount: paxCount)
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Aux Functions
    private func enableDisableButtons() {
        validateAdultNumber()
        validateTeenNumber()
        validateChildrenNumber()
    }

    private func validateAdultNumber() {
        minusAdult.isEnabled = totalAdults != totalPax.minAdults
        plusAdult.isEnabled = totalAdults != totalPax.maxAdults
    }

    private func validateTeenNumber() {
        minusTeen.isEnabled = totalTeen != totalPax.minTeen
        plusTeen.isEnabled = totalTeen != totalPax.maxTeen
    }

    private func validateChildrenNumber() {
        minusChild.isEnabled = totalChildren != totalPax.minChildren
        plusChild.isEnabled = totalChildren != totalPax.maxChildren
    }
}
