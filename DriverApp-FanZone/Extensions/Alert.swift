//
//  Alert.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/04/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = "OK", buttonAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            buttonAction?()
        })
        self.present(alert, animated: true)
    }
}

