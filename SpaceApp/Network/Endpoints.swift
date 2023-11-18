//
//  Endpoints.swift
//  SpaceApp
//
//  Created by Filipe Merli on 14/11/2023.
//

import Foundation

enum ClientError: Error {
    case invalidURL
    case networkDecodingError
    case imageDecodingError
    case networkResponseError
}

protocol APIFetcherProtocol: Sendable {
    func getCompanyInfo() async throws -> CompanyResponseModel
    func getLaunches() async throws -> [LaunchResponseModel]
    func getRocketInfo(by id: String) async throws -> RocketResponseModel
}

final class API: APIFetcherProtocol {

    private static let base: String = "https://api.spacexdata.com"
    private static let company: String = "/v4/company"
    private static let launches: String = "/v5/launches"
    private static let rocket: String = "/v4/rockets/"

    func getCompanyInfo() async throws -> CompanyResponseModel {
        let url = try await Self.buildUrlFromString(string: API.base + API.company)

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ClientError.networkResponseError }
        do {
            let parsedData = try JSONDecoder().decode(CompanyResponseModel.self, from: data)
            return parsedData
        } catch {
            throw ClientError.networkDecodingError
        }
    }

    func getLaunches() async throws -> [LaunchResponseModel] {
        let url = try await Self.buildUrlFromString(string: API.base + API.launches)

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ClientError.networkResponseError }
        do {
            let parsedData = try Self.buildCustomDecoder().decode([LaunchResponseModel].self, from: data)
            return parsedData
        } catch {
            throw ClientError.networkDecodingError
        }
    }

    func getRocketInfo(by id: String) async throws -> RocketResponseModel {
        let url = try await Self.buildUrlFromString(string: API.base + API.rocket + id)

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ClientError.networkResponseError }
        do {
            let parsedData = try JSONDecoder().decode(RocketResponseModel.self, from: data)
            return parsedData
        } catch {
            throw ClientError.networkDecodingError
        }
    }

    private static func buildCustomDecoder() -> JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

// MARK: - Private

fileprivate extension API {

    static func buildUrlFromString(string: String) async throws -> URL {
        guard let url: URL = .init(string: string) else {
            throw ClientError.invalidURL
        }
        return url
    }
}
