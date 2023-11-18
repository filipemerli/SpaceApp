//
//  ListViewControllerCell.swift
//  SpaceApp
//
//  Created by Filipe Merli on 15/11/2023.
//

import UIKit

typealias GetImages = (_ imgView: UIImageView, @escaping (Result<UIImage, Error>) -> Void) -> Void

final class ListViewControllerCell: UITableViewCell {

    // MARK: Properties

    private(set) lazy var imageContainerView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private(set) lazy var missionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var rocketLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .light)
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

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private(set) lazy var symbolContainerView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var adapter: ImageLoaderProtocol?

    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        missionLabel.text = nil
        dateLabel.text = nil
        rocketLabel.text = nil
        daysLabel.text = nil
        imageContainerView.image = nil
        adapter?.cancelImageLoad(imageView: imageContainerView)
    }

    // MARK: Public method

    func populateCell(model: ListCellViewModel, adapter: ImageLoaderProtocol = ImageLoaderAdapter()) {
        self.adapter = adapter
        missionLabel.text = model.mission
        dateLabel.text = model.dateTime
        rocketLabel.text = model.rocket
        daysLabel.text = model.daysNow
        setSymbolImage(success: model.wasLauchSuccessful)
        self.adapter?.loadImage(at: URL(string: model.imageUrl ?? "https://")!, imageView: imageContainerView) // TODO: Use String not URL
    }
}

// MARK: - Private

private extension ListViewControllerCell {
    func setUpViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageContainerView)
        stackView.addArrangedSubview(labelsStackView)
        stackView.addArrangedSubview(symbolContainerView)
        labelsStackView.addArrangedSubview(missionLabel)
        labelsStackView.addArrangedSubview(dateLabel)
        labelsStackView.addArrangedSubview(rocketLabel)
        labelsStackView.addArrangedSubview(daysLabel)
        setUpConstraints()
    }

    func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageContainerView.widthAnchor.constraint(equalToConstant: 75),
            imageContainerView.heightAnchor.constraint(equalToConstant: 75),
            symbolContainerView.topAnchor.constraint(equalTo: stackView.topAnchor),
            symbolContainerView.widthAnchor.constraint(equalToConstant: 30),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: imageContainerView.heightAnchor, constant: 16)
        ])
    }

    func setSymbolImage(success: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.symbolContainerView.image = success 
            ? UIImage(systemName: "checkmark")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            : UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }
    }
}
