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
        }, secondButtonAction: {
            self.dismiss(animated: true)
        })
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
