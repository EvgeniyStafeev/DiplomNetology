//
//  ProfilePostCell.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 07.07.2023.
//

import UIKit

protocol ProfilePostCellDelegate: AnyObject {
    func didTapArticle(post: Post)
    func didTapIsLike(post: Post, indexPath: IndexPath)
    func didTapIsFavorite(post: Post, indexPath: IndexPath)
}

final class ProfilePostCell: UICollectionViewCell {

    weak var delegate: ProfilePostCellDelegate?
    private var post: Post?
    var indexPath: IndexPath?
    private lazy var thumbnail = UIImageView()

    private lazy var article: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var likeIcon = UIImageView()
    private lazy var favoriteIcon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        setSubviews(thumbnail, article, likeIcon, favoriteIcon)
        setGesture()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(post: Post) {
        self.post = post

        thumbnail.image = UIImage(named: post.thumbnail ?? "")
        article.text = post.article?.limitedText(to: 120)

        let likeImage = post.isLike ? "heart.fill" : "heart"
        likeIcon.image = UIImage(systemName: likeImage)

        let favoriteImage = post.isFavorite ? "bookmark.fill" : "bookmark"
        favoriteIcon.image = UIImage(systemName: favoriteImage)
    }

    private func setSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }

    // MARK: - Actions
    @objc
    private func didTapArticle() {
        guard let post = post else { return }
        delegate?.didTapArticle(post: post)
    }

    @objc
    private func didTapIsLike() {
        guard let post = post, let indexPath = indexPath else { return }
        delegate?.didTapIsLike(post: post, indexPath: indexPath)
    }

    @objc
    private func didTapIsFavorite() {
        guard let post = post, let indexPath = indexPath else { return }
        delegate?.didTapIsFavorite(post: post, indexPath: indexPath)
    }
}

// MARK: - GestureRecognizer
extension ProfilePostCell {
    private func setGesture() {
        let tapThumbnailGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArticle))
        thumbnail.addGestureRecognizer(tapThumbnailGesture)
        thumbnail.isUserInteractionEnabled = true

        let tapArticleGesture = UITapGestureRecognizer(target: self, action: #selector(didTapArticle))
        article.addGestureRecognizer(tapArticleGesture)
        article.isUserInteractionEnabled = true

        let tapIsLikeGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsLike))
        likeIcon.addGestureRecognizer(tapIsLikeGesture)
        likeIcon.isUserInteractionEnabled = true

        let tapIsFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapIsFavorite))
        favoriteIcon.addGestureRecognizer(tapIsFavoriteGesture)
        favoriteIcon.isUserInteractionEnabled = true
    }
}

// MARK: - setConstraints
extension ProfilePostCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnail.heightAnchor.constraint(equalToConstant: 200),
            thumbnail.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnail.trailingAnchor.constraint(equalTo: trailingAnchor),

            article.topAnchor.constraint(equalTo: thumbnail.bottomAnchor, constant: 10),
            article.leadingAnchor.constraint(equalTo: leadingAnchor),
            article.trailingAnchor.constraint(equalTo: trailingAnchor),

            likeIcon.widthAnchor.constraint(equalToConstant: 28),
            likeIcon.heightAnchor.constraint(equalToConstant: 28),
            likeIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 7),
            likeIcon.leadingAnchor.constraint(equalTo: leadingAnchor),

            favoriteIcon.widthAnchor.constraint(equalToConstant: 25),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 25),
            favoriteIcon.topAnchor.constraint(equalTo: article.bottomAnchor, constant: 10),
            favoriteIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
