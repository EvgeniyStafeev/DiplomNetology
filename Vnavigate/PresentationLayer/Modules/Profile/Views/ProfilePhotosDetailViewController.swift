//
//  ProfilePhotosDetailViewController.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 26.07.2023.
//

import UIKit

final class ProfilePhotosDetailViewController: UIViewController {

    private let viewModel: ProfilePhotosDetailViewModel

    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(viewModel: ProfilePhotosDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setGesture()
        setConstraints()
    }

    private func setUI() {
        view.backgroundColor = .black
        view.addSubview(photoView)

        photoView.image = UIImage(named: viewModel.photo.image ?? "")
    }

    // MARK: - Actions
    @objc
    private func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - GestureRecognizer
extension ProfilePhotosDetailViewController {
    private func setGesture() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        gesture.direction = .down
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
}

// MARK: - Set constraints
extension ProfilePhotosDetailViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: view.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
