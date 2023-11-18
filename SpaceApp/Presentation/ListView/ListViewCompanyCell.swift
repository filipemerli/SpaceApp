//
//  ListViewCompanyCell.swift
//  SpaceApp
//
//  Created by Filipe Merli on 18/11/2023.
//

import UIKit

final class ListViewCompanyCell: UITableViewCell {

    // MARK: Properties

    private(set) lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String? = "companyCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public method

    func populateCell(model: CompanyViewModel) {
        mainLabel.text = model.description
    }
}

// MARK: - Private

private extension ListViewCompanyCell {
    func setUpViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(mainLabel)
        setUpConstraints()
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: stackView.heightAnchor, constant: 32)
        ])
    }
}
