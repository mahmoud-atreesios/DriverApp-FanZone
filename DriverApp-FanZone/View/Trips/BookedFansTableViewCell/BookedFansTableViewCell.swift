//
//  BookedFansTableViewCell.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 29/04/2024.
//

import UIKit

class BookedFansTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fanID: UILabel!
    @IBOutlet weak var numberOfSeats: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    
    var rightButtonStalker = false
    var leftButtonStalker = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        mainView.layer.cornerRadius = 10
        
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        rightButtonStalker.toggle()
        if rightButtonStalker{
            rightButton.tintColor = .black
        }else{
            rightButton.tintColor = .darkGray
        }
        print("right button pressed")
    }
    
    @IBAction func wrongButtonPressed(_ sender: UIButton) {
    }
    
}
