//
//  HomeViewController.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 09.07.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let coordinator: HomeCoordinator
    private let viewModel: HomeViewModel
    private var dataSource: HomeDiffableDataSource?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        return activityIndicator
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: HomeCompositionalLayout { [weak self] in
                self?.viewModel.dataSourceSnapshot.sectionIdentifiers[$0].layoutType ?? .friendsLayout
            })
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(coordinator: HomeCoordinator, viewModel: HomeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureColletionView()
        setConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeState(.loading)
        collectionView.reloadData()
    }

    // MARK: - changeState
    func changeState(_ state: State) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            viewModel.fethc()
        case .loaded:
            activityIndicator.stopAnimating()
            dataSource?.apply(viewModel.dataSourceSnapshot)
        case .error(_):
            showAlert(with: "Ошибка", and: "Ошибка загрузки данных")
        }
    }

    // MARK: - configureColletionView
    private func configureColletionView() {
        view.addSubview(collectionView)

        let homeFriendCellRegistration = UICollectionView.CellRegistration<HomeFriendCell, Author> { cell, indexPath, author in
            cell.configure(author: author)
            cell.delegate = self
        }

        let homePostCellRegistration = UICollectionView.CellRegistration<HomePostCell, Post> { cell, indexPath, post in
            cell.configure(post: post)
            cell.delegate = self
            cell.indexPath = indexPath
        }

        dataSource = HomeDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, section in

            switch section {
            case .friendsItem(let author):
                return collectionView.dequeueConfiguredReusableCell(using: homeFriendCellRegistration, for: indexPath, item: author)

            case .postsItem(let post):
                return collectionView.dequeueConfiguredReusableCell(using: homePostCellRegistration, for: indexPath, item: post)
            }
        }
    }
}

// MARK: - HomeFriendCellDelegate
extension HomeViewController: HomeFriendCellDelegate {
    func didTapFriendAvatar(author: Author) {
        coordinator.coordinateToHomeAuthorProfile(author: author)
    }
}

// MARK: - HomePostCellDelegate
extension HomeViewController: HomePostCellDelegate {
    func didTapAvatar(author: Author) {
        coordinator.coordinateToHomeAuthorProfile(author: author)
    }

    func didTapArticle(post: Post) {
        coordinator.coordinateToHomePostDetail(post: post)
    }

    func didTapIsLike(post: Post, indexPath: IndexPath) {
        let isLike = !post.isLike
        post.setValue(isLike, forKey: "isLike")
        CoreDataManager.shared.save()

        guard let selectedLike = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reconfigureItems([selectedLike])
        dataSource?.apply(snapshot)
    }

    func didTapIsFavorite(post: Post, indexPath: IndexPath) {
        let isFavorite = !post.isFavorite
        post.setValue(isFavorite, forKey: "isFavorite")
        CoreDataManager.shared.save()

        guard let selectedFavorite = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reconfigureItems([selectedFavorite])
        dataSource?.apply(snapshot)
    }
}

// MARK: - setConstraints
extension HomeViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
