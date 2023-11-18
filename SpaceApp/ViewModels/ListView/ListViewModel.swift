//
//  ListViewModel.swift
//  SpaceApp
//
//  Created by Filipe Merli on 15/11/2023.
//

import Foundation

struct ListViewModel {

    enum SectionType: String, CaseIterable {
        case company, launches
    }

    private let setions: [SectionType] = SectionType.allCases

    init() {
        print(setions)
    }
}
