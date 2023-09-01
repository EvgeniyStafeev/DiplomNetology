//
//  UIAlertController+Extension.swift
//  Vnavigate
//
//  Created by Евгений Стафеев on 05.07.2023.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        navigationController?.present(alertController, animated: true)
    }
}
