//
//  ProfileCompositionalLayout.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 30.06.2023.
//

import UIKit

final class ProfileCompositionalLayout: UICollectionViewCompositionalLayout {

    init(layoutTypeProvider: @escaping (Int) -> ProfileSection.LayoutType) {
        super.init(
            sectionProvider: { index, environment in
                return layoutTypeProvider(index).section(environment: environment)
            },
            configuration: {
                return UICollectionViewCompositionalLayoutConfiguration()
            }())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
