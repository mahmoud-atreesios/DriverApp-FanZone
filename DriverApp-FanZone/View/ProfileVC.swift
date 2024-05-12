//
//  ProfileVC.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 21/04/2024.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import SDWebImage

class ProfileVC: UIViewController {

    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var totalSalary: UILabel!
    @IBOutlet weak var completedTripsTableView: UITableView!
    
    let viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        bindDriverData()
        bindCompletedTripsTableViewToViewModel()
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

extension ProfileVC{
    func bindCompletedTripsTableViewToViewModel(){
        viewModel.tripsData
            .asObservable()
            .bind(to: completedTripsTableView.rx.items(cellIdentifier: "tripsCell", cellType: TripsTableViewCell.self)) { index, trips, cell in
                                
                cell.busStation.text = trips.station
                cell.busDestination.text = trips.destination
                cell.travelTime.text = ""
                cell.numberOfFans.text = "\(trips.driverPrice)$"
                cell.detailsLabel.text = "completed"
                
                let driverPrices = self.viewModel.tripsData.value.compactMap { Int($0.driverPrice) }
                let totalDriverPrice = driverPrices.reduce(0, +) // Calculate the sum of driver prices
                
                self.totalSalary.text = "Total: \(totalDriverPrice)$"

            }
            .disposed(by: disposeBag)
    }
}

extension ProfileVC{
    func bindDriverData(){
        viewModel.driverData
            .subscribe(onNext: {driver in
                
                if let driverName = driver["name"]{
                    self.driverName.text = driverName
                }
                
                if let image = driver["driverImageUrl"]{
                    self.driverImage.sd_setImage(with: URL(string: image))
                }
                
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileVC{
    func setUp(){
        driverImage.makeRounded()
        viewModel.fetchDriverData()
        viewModel.fetchTripsData(selectedDate: nil, tripStatus: "completed")
        completedTripsTableView.register(UINib(nibName: "TripsTableViewCell", bundle: nil), forCellReuseIdentifier: "tripsCell")
    }
}
