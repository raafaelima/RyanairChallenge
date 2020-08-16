//
//  JSONDecoderMock.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 16/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
@testable import RyanairChallenge

enum ErrorMock: Error {
    case anError
}

class JSONDecoderMock: JSONDecoder {

    var decodedObject: Any?
    var toDecodedData: Data?

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        toDecodedData = data
        return decodedObject as! T
    }
}

class JSONDecoderFailureMock: JSONDecoder {
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        throw ErrorMock.anError
    }
}
