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
    @IBOutlet weak var hidePasswordImageView: UIImageView!
    
    let tabBarVC = TabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.tintColor = UIColor(red: 138/255, green: 134/255, blue: 97/255, alpha: 1.0)
        hideKeyboardWhenTappedAround()
        makeHidePasswordImageViewClickable()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = driverEmail.text, !email.isEmpty else {
            showAlert(title: "Email Required", message: "Please enter your email.", firstButtonTitle: "Ok", firstButtonAction: {
                self.dismiss(animated: true)
            })
            return
        }
        guard let password = driverPassword.text, !password.isEmpty else {
            showAlert(title: "Password Required", message: "Please enter your password.", firstButtonTitle: "Ok", firstButtonAction: {
                self.dismiss(animated: true)
            })
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if error != nil{
                self.showAlert(title: "Error!", message: "The email or password is not correct")
            }else{
                print("++++++++++++    ++++++++++++   logged in succefully")
                // Present the tab bar controller
                self.tabBarVC.modalPresentationStyle = .fullScreen
                self.present(self.tabBarVC, animated: true, completion: nil)
            }
        }
    }
}

extension SignIn{
    func makeHidePasswordImageViewClickable(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        hidePasswordImageView.isUserInteractionEnabled = true
        hidePasswordImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func togglePasswordVisibility() {
        driverPassword.isSecureTextEntry.toggle()
        hidePasswordImageView.image = driverPassword.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
    }
}


// MARK: - HIDE KEYBOARD
extension SignIn{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignIn.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
