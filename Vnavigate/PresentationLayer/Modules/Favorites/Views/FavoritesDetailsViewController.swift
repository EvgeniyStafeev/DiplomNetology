//
//  FavoritesDetailsViewController.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 05.07.2023.
//

import UIKit

final class FavoritesDetailsViewController: UIViewController {

    private let post: Post
    private lazy var avatar = CircularImageView()
    private lazy var name = UILabel()

    private lazy var profession: UILabel = {
        let label = UILabel()
        label.textColor = CustomColor.gray
        return label
    }()

    private lazy var thumbnail = UIImageView()

    private lazy var article: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var likeIcon = UIImageView()
    private lazy var favoriteIcon = UIImageView()

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSubviews(avatar, name, profession, thumbnail, article, likeIcon, favoriteIcon)
        setUI()
        setGesture()
        setConstraints()
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
    }

    private func setUI() {
        view.backgroundColor = .systemBackground

        avatar.image = UIImage(named: post.author?.avatar ?? "")
        name.text = post.author?.name
        profession.text = post.author?.profession
        thumbnail.image = UIImage(named: post.thumbnail ?? "")
        article.text = post.article

        let likeImage = post.isLike ? "heart.fill" : "heart"
        likeIcon.image = UIImage(systemName: likeImage)

        let favoriteImage = post.isFavorite ? "bookmark.fill" : "bookmark"
        favoriteIcon.image = UIImage(systemName: favoriteImage)
    }

    // MARK: - Actions
    @objc
    private func didTapIsLike() {
        let like = !post.isLike
        post.setValue(like, forKey: "isLike")
        CoreDataManager.shared.save()

        let likeImage = post.isLike ? "heart.fill" : "heart"
        likeIcon.image = UIImage(systemName: likeImage)
    }

    @objc
    private func didTapIsFavorite() {
        let favorite = !post.isFavorite
        post.setValue(favorite, forKey: "isFavorite")
        CoreDataManager.shared.save()

        navigationController?.popViewController(animated: true)
    }

}
// MARK: - GestureRecognizer
extension FavoritesDetailsViewController {
    private func setGesture() {
        let tapIsLikeGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsLike))
        likeIcon.addGestureRecognizer(tapIsLikeGesture)
        likeIcon.isUserInteractionEnabled = true

        let tapIsFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsFavorite))
        favoriteIcon.addGestureRecognizer(tapIsFavoriteGesture)
        favoriteIcon.isUserInteractionEnabled = true
    }
}

// MARK: - Set constraints
extension FavoritesDetailsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            name.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 7),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),

            profession.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            profession.leadingAnchor.constraint(equalTo: name.leadingAnchor),

            thumbnail.heightAnchor.constraint(equalToConstant: 200),
            thumbnail.topAnchor.constraint(equalTo: profession.bottomAnchor, constant: 20),
            thumbnail.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thumbnail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            article.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 10),
            article.leadingAnchor.constraint(equalTo: thumbnail.leadingAnchor),
            article.trailingAnchor.constraint(equalTo: thumbnail.trailingAnchor),

            likeIcon.widthAnchor.constraint(equalToConstant: 28),
            likeIcon.heightAnchor.constraint(equalToConstant: 28),
            likeIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 7),
            likeIcon.leadingAnchor.constraint(equalTo: article.leadingAnchor),

            favoriteIcon.widthAnchor.constraint(equalToConstant: 25),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 25),
            favoriteIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 10),
            favoriteIcon.trailingAnchor.constraint(equalTo: article.trailingAnchor),
        ])
    }
}
