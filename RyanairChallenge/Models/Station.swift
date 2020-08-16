//
//  Station.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

struct Stations: Codable {
    var stations: [Station]?
}

struct Station: Codable {
    let code: String
    let name: String
    let countryName: String

    func toLabel() -> String {
        return "\(name) (\(code)) - \(countryName)"
    }
}
