//
//  CustomLoader.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 10/05/2024.
//

import UIKit

class CustomLoaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.center = center
    }
}
