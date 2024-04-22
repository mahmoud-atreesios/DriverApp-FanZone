//
//  ViewController.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/04/2024.
//

import UIKit
import Firebase

class SignIn: UIViewController {
    
    @IBOutlet weak var driverEmail: UITextField!
    @IBOutlet weak var driverPassword: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let tabBarVC = TabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.tintColor = UIColor(red: 138/255, green: 134/255, blue: 97/255, alpha: 1.0)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = driverEmail.text, !email.isEmpty else {
            //LoaderManager.shared.hideBallLoader()
            //blurEffectView.removeFromSuperview()
            //self.isSavingData = false
            //self.loginButton.isEnabled = true
            showAlert(title: "Email Required", message: "Please enter your email.")
            return
        }
        guard let password = driverPassword.text, !password.isEmpty else {
            //LoaderManager.shared.hideBallLoader()
            //blurEffectView.removeFromSuperview()
            //self.isSavingData = false
            //self.loginButton.isEnabled = true
            showAlert(title: "Password Required", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if error != nil{
                //LoaderManager.shared.hideBallLoader()
                //blurEffectView.removeFromSuperview()
                //self.isSavingData = false
                //self.loginButton.isEnabled = true
                self.showAlert(title: "Error!", message: "The email or password is not correct")
            }else{
                print("++++++++++++    ++++++++++++   logged in succefully")
                // Present the tab bar controller
                self.tabBarVC.modalPresentationStyle = .fullScreen
                self.present(self.tabBarVC, animated: true, completion: nil)
                // self.signInButton.isEnabled = true
            }
        }
    }
}

extension SignIn{
}
