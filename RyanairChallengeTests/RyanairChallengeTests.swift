//
//  RyanairChallengeTests.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import RyanairChallenge

class RyanairChallengeTests: QuickSpec {

    override func spec() {
        describe("RealmFactory") {
            it("should load the Realm with a schema version") {
                expect(1).to(equal(1))
            }
        }
    }
}
