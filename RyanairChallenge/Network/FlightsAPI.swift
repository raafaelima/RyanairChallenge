//
//  FlightsAPI.swift
//  RyanairChallenge
//
//  Created by Rafael Lima on 12/08/2020.
//  Copyright © 2020 RCL. All rights reserved.
//

import Foundation

protocol FlightAPIType: class {
    func getStations(completion: @escaping (Result<Stations, Error>) -> Void)
    func searchFlights(_ params: FlightSearchData, completion: @escaping (Result<TripList, Error>) -> Void)
}

class FlightAPI: FlightAPIType {

    var decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        self.setDateDecodingStrategy()
    }

    func getStations(completion: @escaping (Result<Stations, Error>) -> Void) {
        let url = URL(string: "https://tripstest.ryanair.com/static/stations.json")
        requestObjectWith(url: url, completion: completion)
    }

    func searchFlights(_ params: FlightSearchData, completion: @escaping (Result<TripList, Error>) -> Void) {

        let url = "https://sit-nativeapps.ryanair.com/api/v4/Availability?roundtrip=false&ToUs=AGREED"
        let queryParams = buildSearchFlightParams(params)

        let requestURL = createURLAndAppendQueryItens(url, queryParams)
        requestObjectWith(url: requestURL, completion: completion)
    }

    private func requestObjectWith<T: Codable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void) {

        guard let baseURL = url else {
            return
        }

        var urlRequest = URLRequest(url: baseURL)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        let remoteDataTask = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let receivedData = data {
                do {
                    let objectResponse = try self.decoder.decode(T.self, from: receivedData)
                    completion(.success(objectResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error!))
            }
        }
        remoteDataTask.resume()
    }

    private func createURLAndAppendQueryItens(_ url: String, _ customQueryParams: [URLQueryItem]) -> URL? {
        var components = URLComponents(string: url)
        components?.queryItems?.append(contentsOf: customQueryParams)
        return components?.url
    }

    private func buildSearchFlightParams(_ searchData: FlightSearchData) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "origin", value: searchData.origin.code),
            URLQueryItem(name: "destination", value: searchData.destination.code),
            URLQueryItem(name: "dateout", value: searchData.formattedDepartureDate()),
            URLQueryItem(name: "adt", value: "\(searchData.paxCount.adults)"),
            URLQueryItem(name: "teen", value: "\(searchData.paxCount.teen)"),
            URLQueryItem(name: "chd", value: "\(searchData.paxCount.children)")
        ]
    }

    private func setDateDecodingStrategy() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        self.decoder.dateDecodingStrategy = .formatted(formatter)
    }
}
