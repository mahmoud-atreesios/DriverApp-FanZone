//
//  TripsTableViewCell.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 25/04/2024.
//

import UIKit

class TripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fixedImage: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var busStation: UILabel!
    @IBOutlet weak var busDestination: UILabel!
    
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var estimatedArrivalTime: UILabel!
    
    @IBOutlet weak var numberOfFans: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var tapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        makeDetailsButtonClickable()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func makeDetailsButtonClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(detailsLabelTapped))
        detailsLabel.addGestureRecognizer(tapGesture)
        detailsLabel.isUserInteractionEnabled = true
    }
    
    @objc func detailsLabelTapped() {
        tapAction?()
    }
    
}

extension TripsTableViewCell{
    func setupUI(){
        topView.layer.borderWidth = 1
        topView.layer.cornerRadius = 10
        topView.layer.borderColor = UIColor.lightGray.cgColor
        numberOfFans.layer.cornerRadius = 10
        numberOfFans.layer.masksToBounds = true
        detailsLabel.layer.cornerRadius = 10
        detailsLabel.layer.masksToBounds = true
        fixedImage.makeRounded()
    }
}
