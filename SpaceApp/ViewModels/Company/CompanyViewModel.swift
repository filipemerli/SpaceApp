//
//  CompanyViewModel.swift
//  SpaceApp
//
//  Created by Filipe Merli on 14/11/2023.
//

import Foundation

struct CompanyViewModel {
    static let title = "Company"
    let description: String

    init(dto: CompanyResponseModel) {
        self.description = dto.name + " was founded by " + dto.founder + " in " + String(dto.founded) +
        ". It has now " + String(dto.employees) + " employees, " + String(dto.launchSites) +
        " launch sites, and is valued at USD " + String(dto.valuation)
    }
}
