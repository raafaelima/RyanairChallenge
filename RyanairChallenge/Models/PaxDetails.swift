//
//  PaxDetails.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

struct PaxDetails {
    var adults: Int
    var teen: Int
    var children: Int

    func toLabel() -> String {
        return "\(adults) Aldults - \(teen) Teens - \(children) Children"
    }
}
