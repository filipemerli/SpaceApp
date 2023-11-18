//
//  ListViewController.swift
//  SpaceApp
//
//  Created by Filipe Merli on 15/11/2023.
//

import UIKit
import Combine

class ListViewController: UITableViewController {

    // MARK: Properties

    private enum Constants { static let reusableIdentifier = "albumCell" }

    private var cellsModel: [ListCellViewModel] = []
    private var companyModel: CompanyViewModel?
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: ListViewControllerViewModelProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpaceX"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListViewControllerCell.self, forCellReuseIdentifier: Constants.reusableIdentifier)
        bindToViewModel()
        viewModel.loadData()
    }

    // MARK: Lifecycle

    init(viewModel: ListViewControllerViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate/Datasource

extension ListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == .zero ? (companyModel != nil ? 1 : .zero) : cellsModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellsModel.count > 0 && indexPath.section == 1 { 
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.reusableIdentifier, for: indexPath
            ) as? ListViewControllerCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.populateCell(model: cellsModel[indexPath.row])
            return cell
        } else if (indexPath.section == .zero), let companyModel = companyModel {
            let cell = ListViewCompanyCell(style: .default)
            cell.populateCell(model: companyModel)
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard companyModel != nil else { return nil }
        return section == .zero ? "COMPANY" : "LAUNCHES"
    }
}

private extension ListViewController {
    func bindToViewModel() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in

                guard let self else { return }
                switch newState {
                case let .loaded(cellsModel, companyModel):
                    self.cellsModel = cellsModel
                    self.companyModel = companyModel
                    self.tableView.reloadData()
                case .loading, .idle:
                    debugPrint("Loading state to implement")
                case let .error(error):
                    debugPrint(error)
                }
            }.store(in: &cancellable)
    }
}
