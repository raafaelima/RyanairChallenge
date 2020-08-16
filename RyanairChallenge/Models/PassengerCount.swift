//
//  PassengerCount.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 13/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

struct PassengerCount {
    var adults: Int
    var teen: Int
    var children: Int

    func totalPax() -> Int {
        return adults + teen + children
    }

    func hasTeenOrChildren() -> Bool {
        return teen > 0 || children > 0
    }
}
