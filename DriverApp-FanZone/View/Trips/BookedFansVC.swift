//
//  BookedFansVC.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 29/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class BookedFansVC: UIViewController {
    
    @IBOutlet weak var bookedFansTableView: UITableView!
    @IBOutlet weak var startTripButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    var busNumber: String = ""
    var travelDate: String = ""
    var station: String = ""
    var destination: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startTripButton.tintColor = UIColor(red: 138/255, green: 134/255, blue: 97/255, alpha: 1.0)
        bookedFansTableView.register(UINib(nibName: "BookedFansTableViewCell", bundle: nil), forCellReuseIdentifier: "bookedFanCell")
        viewModel.BookedFans(busNumber: busNumber, travelDate: travelDate, station: station, destination: destination)
        bindBookedFansTableViewToViewModel()
    }
    
    @IBAction func startTripButtonPressed(_ sender: UIButton) {
        showAlert(title: "The Trip is about to start.", message: "✅", firstButtonTitle: "Get Direction", secondButtonTitle: "Cancel", firstButtonAction: {
            for cell in self.bookedFansTableView.visibleCells as! [BookedFansTableViewCell] {
                if cell.rightButtonStalker {
                    if let fanID = cell.fanId {
                        self.viewModel.updateFanBusTicketStatus(fanid: fanID, busNumber: self.busNumber, travelDate: self.travelDate, station: self.station, destination: self.destination, newTicketStatus: "Boarded")
                    }
                } else if cell.leftButtonStalker {
                    if let fanID = cell.fanId {
                        self.viewModel.updateFanBusTicketStatus(fanid: fanID, busNumber: self.busNumber, travelDate: self.travelDate, station: self.station, destination: self.destination, newTicketStatus: "Absent")
                    }
                }
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let directionVC = storyboard.instantiateViewController(withIdentifier: "DirectionVC") as? DirectionVC {
                self.setLongAndLat(destination: self.destination)
                directionVC.destination = self.destination
                directionVC.latitude = self.latitude
                directionVC.longitude = self.longitude
                self.navigationController?.pushViewController(directionVC, animated: true)
            }
        }, secondButtonAction: {
            self.dismiss(animated: true)
        })
    }
}

extension BookedFansVC {
    func setLongAndLat(destination: String) {
        let coordinates: [String: (Double, Double)] = [
            "Alexandria Stadium": (31.1971, 29.9132),
            "We Salam Stad": (30.1744, 31.4348),
            "Ismalia Stadium": (30.6015, 32.2741)
        ]
        
        if let (latitude, longitude) = coordinates[destination] {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}


extension BookedFansVC{
    func bindBookedFansTableViewToViewModel(){
        viewModel.bookedFans
            .asObservable()
            .bind(to: bookedFansTableView.rx.items(cellIdentifier: "bookedFanCell", cellType: BookedFansTableViewCell.self)) { (row, fan, cell) in
                if let fanID = fan["userID"]?.prefix(4) {
                    cell.fanID.text = String(fanID)
                }
                cell.fanId = fan["userID"]
                cell.numberOfSeats.text = fan["numberOfSeats"]
            }
            .disposed(by: disposeBag)
    }
}

extension BookedFansVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
