//
//  ProfileVC.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/04/2024.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutBarButtonPressed(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("User signed out successfully")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignIn") as? SignIn {
                    signInVC.modalPresentationStyle = .fullScreen
                    present(signInVC, animated: true, completion: nil)
                }
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}
