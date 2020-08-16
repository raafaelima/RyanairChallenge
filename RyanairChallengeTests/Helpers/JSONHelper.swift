//
//  File.swift
//  RyanairChallengeTests
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation
import UIKit

class JSONHelper {

    class func getObjectFrom<T: Codable>(json file: String, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        decoder.dateDecodingStrategy = .formatted(formatter)

        guard let jsonData = getDataFrom(json: file) else {
            return nil
        }
        if let objDecoded = try? decoder.decode(T.self, from: jsonData) {
            return objDecoded
        }
        return nil
    }

    class func getDataFrom(json file: String) -> Data? {
        if let path = Bundle(for: JSONHelper.self).path(forResource: file, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                fatalError("Wrong Format JSON")
            }
        }
        fatalError("Wrong Format JSON")
    }
}
