//
//  ViewController.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/04/2024.
//

import UIKit

class SignIn: UIViewController {
    
    @IBOutlet weak var driverEmail: UITextField!
    @IBOutlet weak var driverPassword: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.tintColor = UIColor(red: 138/255, green: 134/255, blue: 97/255, alpha: 1.0)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    
}

