//
//  StationTableViewCell.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityCodeLabel: UILabel!

    func initView(station: Station) {
        self.cityLabel.text = station.name
        self.cityCodeLabel.text = station.code
        self.countryLabel.text = station.countryName
    }
}
