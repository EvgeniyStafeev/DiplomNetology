//
//  FavoritesCompositionLayout.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 30.07.2023.
//

import UIKit

final class FavoritesCompositionLayout: UICollectionViewCompositionalLayout {
    
    init(layoutTypeProvider: @escaping (Int) -> FavoritesSection.LayoutType) {
        super.init(
            sectionProvider: { index, environment in
                let section = layoutTypeProvider(index).section(environment: environment)
                return section
            },
            configuration: {
                let configuration = UICollectionViewCompositionalLayoutConfiguration()
                return configuration
            }())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
