//
//  CompanyResponseModel.swift
//  SpaceApp
//
//  Created by Filipe Merli on 14/11/2023.
//

import Foundation

struct CompanyResponseModel: Decodable {
    let name: String
    let founder: String
    let founded: Int
    let employees: Int
    let launchSites: Int
    let valuation: Int64

    private enum CodingKeys : String, CodingKey {
        case name, founder, founded, employees, launchSites = "launch_sites", valuation
    }
}
