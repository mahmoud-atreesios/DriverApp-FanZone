//
//  CollectionViewCell.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/04/2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var dayName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
    }

}
