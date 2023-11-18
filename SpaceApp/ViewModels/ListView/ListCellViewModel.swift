//
//  ListCellViewModel.swift
//  SpaceApp
//
//  Created by Filipe Merli on 15/11/2023.
//

import Foundation

struct ListCellViewModel: Sendable {

    private enum Constants {
        static let missionLabel = "Mission: "
        static let dateLabel = "Date/time: "
        static let rocketLabel = "Rocket: "
        static let daysLabel = "Days "
        static let sinceText = "since "
        static let fromText = "from "
        static let nowText = "now: "
        static let atText = " at "
    }

    let imageUrl: String?
    let mission: String
    let dateTime: String
    let rocket: String
    let daysNow: String
    let wasLauchSuccessful: Bool

    init(imageUrl: String?, mission: String, date: Date?, rocketName: String, rocketType: String, wasLauchSuccessful: Bool) {
        self.imageUrl = imageUrl
        self.mission = Constants.missionLabel + mission
        self.dateTime = Constants.dateLabel + Self.getDate(from: date) + Constants.atText + Self.getTime(from: date)
        self.rocket = Constants.rocketLabel + rocketName + "/" + rocketType
        self.daysNow = Constants.daysLabel + Self.buildDaysNowLabelText(from: date)
        self.wasLauchSuccessful = wasLauchSuccessful
    }

    static func getTime(from: Date?) -> String {
        guard let from else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: from)
    }

    static func buildDaysNowLabelText(from date: Date?) -> String {
        guard let date else { return "" }
        let didHappen = date > .now
        return (didHappen ? Constants.sinceText : Constants.fromText) + Constants.nowText + Self.numberOfDaysFromNow(from: date)
    }

    static func numberOfDaysFromNow(from date: Date?) -> String {
        guard let date else { return "" }
        let days = Calendar.current.dateComponents([.day], from: date, to: .now)
        return String(days.day ?? .zero)
    }

    static func getDate(from date: Date?) -> String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}
