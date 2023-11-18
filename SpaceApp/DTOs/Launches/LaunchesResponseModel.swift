//
//  LaunchesResponseModel.swift
//  SpaceApp
//
//  Created by Filipe Merli on 14/11/2023.
//

import Foundation

struct LaunchResponseModel: Decodable {
    let name: String
    let links: PatchModel
    let success: Bool?
    let date: Date?
    let rocketId: String?

    private enum CodingKeys : String, CodingKey {
        case name, links, success, date = "date_utc", rocketId = "rocket"
    }
}

struct PatchModel: Decodable {
    let patch: ImageUrlString
}

struct ImageUrlString: Decodable {
    let small: String?
}
