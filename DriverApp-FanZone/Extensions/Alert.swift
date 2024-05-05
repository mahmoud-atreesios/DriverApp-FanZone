//
//  Alert.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/04/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, firstButtonTitle: String? = nil, secondButtonTitle: String? = nil, firstButtonAction: (() -> Void)? = nil, secondButtonAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let firstTitle = firstButtonTitle {
            alert.addAction(UIAlertAction(title: firstTitle, style: .default) { _ in
                firstButtonAction?()
            })
        }
        
        if let secondTitle = secondButtonTitle {
            alert.addAction(UIAlertAction(title: secondTitle, style: .default) { _ in
                secondButtonAction?()
            })
        }
        
        self.present(alert, animated: true)
    }
}

