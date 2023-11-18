//
//  ListViewControllerViewModel.swift
//  SpaceApp
//
//  Created by Filipe Merli on 18/11/2023.
//

import Combine

protocol ListViewControllerViewModelProtocol {
    var state: PassthroughSubject<ListViewControllerState, Never> { get }

    func loadData()
}

enum ListViewControllerState {
    case idle
    case loading
    case loaded([ListCellViewModel], CompanyViewModel?)
    case error(Error)
}

final class ListViewControllerViewModel: ListViewControllerViewModelProtocol {

    // MARK: Properties

    let apiFetcher: APIFetcherProtocol
    var state = PassthroughSubject<ListViewControllerState, Never>()
    private var bag = Set<AnyCancellable>()

    func loadData() {
        Task {
            do {
                state.send(.loading)
                let data: CompanyResponseModel = try await apiFetcher.getCompanyInfo()
                let dataL: [LaunchResponseModel] = try await apiFetcher.getLaunches()
                let companyModel = CompanyViewModel(dto: data)
                let cellsModel = await Self.buildFinalModel(models: dataL, fetcher: apiFetcher)
                state.send(.loaded(cellsModel, companyModel))
            } catch let error {
                state.send(.error(error))
            }
        }
    }

    // MARK: Lifecycle

    init(apiFetcher: APIFetcherProtocol) {
        self.apiFetcher = apiFetcher
    }

    deinit {
        bag.removeAll()
    }
}

fileprivate extension ListViewControllerViewModel {
    static func initModelWithouRocket(model: LaunchResponseModel) -> ListCellViewModel {
        .init(
            imageUrl: model.links.patch.small,
            mission: model.name,
            date: model.date,
            rocketName: "Not available",
            rocketType: "",
            wasLauchSuccessful: model.success ?? false
        )
    }

    static func fetchRocketInfo(model: LaunchResponseModel, apiFetcher: APIFetcherProtocol) async -> ListCellViewModel {
        let rocketId: String = model.rocketId ?? ""
        if rocketId != "" {
            do {
                let rocket = try await apiFetcher.getRocketInfo(by: rocketId)
                return .init(
                    imageUrl: model.links.patch.small,
                    mission: model.name,
                    date: model.date,
                    rocketName: rocket.name,
                    rocketType: rocket.type,
                    wasLauchSuccessful: model.success ?? false
                )
            } catch {
                return Self.initModelWithouRocket(model: model)
            }
        } else {
            return Self.initModelWithouRocket(model: model)
        }
    }

    static func buildFinalModel(models: [LaunchResponseModel], fetcher: APIFetcherProtocol) async -> [ListCellViewModel] {
        await withTaskGroup(of: ListCellViewModel.self, returning: [ListCellViewModel].self) { group in
            for mid in models {
                group.addTask { await (Self.fetchRocketInfo(model: mid, apiFetcher: fetcher)) }
            }
            var cellModels: [ListCellViewModel] = []
            for await result in group {
                cellModels.append(result)
            }
            return cellModels
        }
    }
}
