//
//  CircularImageView.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 02.08.2023.
//

import UIKit

final class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}

