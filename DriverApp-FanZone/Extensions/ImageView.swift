//
//  ImageView.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/04/2024.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
