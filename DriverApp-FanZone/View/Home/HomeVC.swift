//
//  HomeVC.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var tripsTableView: UITableView!
        
    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()
    var dates: [(date: Date, display: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dateCell")
        tripsTableView.register(UINib(nibName: "TripsTableViewCell", bundle: nil), forCellReuseIdentifier: "tripsCell")
        binding()
        viewModel.fetchTripsData(selectedDate: todayDate())
        bindingTripsTableViewToViewModel()
    }
    
    func todayDate() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: today)
    }
}

extension HomeVC {
    func binding() {
        let calendar = Calendar.current
        let today = Date()
        
        // Create an array of date strings for today and the next 7 days
        for i in 0...7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd"
                let dayNumber = dateFormatter.string(from: date)
                
                dateFormatter.dateFormat = "EEEE"
                let dayName = dateFormatter.string(from: date)
                let shortenedDayName = String(dayName.prefix(3))
                
                let displayDate = "\(dayNumber)|\(shortenedDayName)"
                dates.append((date: date, display: displayDate)) // Store both the Date object and the display string
            }
        }
        
        Observable.just(dates)
            .bind(to: dateCollectionView.rx.items(cellIdentifier: "dateCell", cellType: CollectionViewCell.self)) { index, data, cell in
                let components = data.display.components(separatedBy: "|")
                cell.dayNumber.text = components.first
                cell.dayName.text = components.last
                cell.backgroundColor = self.viewModel.selectedIndexPath.value == IndexPath(item: index, section: 0) ? UIColor.lightGray : UIColor.white
            }
            .disposed(by: disposeBag)
        
        dateCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let dates = self?.dates, indexPath.item < dates.count else { return }
                let selectedDate = dates[indexPath.item].date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: selectedDate)
                
                self?.viewModel.fetchTripsData(selectedDate: formattedDate)
                
                print("Cell tapped at index: \(indexPath.item), Date: \(formattedDate)")
                self?.viewModel.selectedIndexPath.accept(indexPath)
                self?.dateCollectionView.reloadData()
                
            })
            .disposed(by: disposeBag)
    }
}

extension HomeVC {
    func bindingTripsTableViewToViewModel(){
        viewModel.tripsData
            .asObservable()
            .bind(to: tripsTableView.rx.items(cellIdentifier: "tripsCell", cellType: TripsTableViewCell.self)) { index, trips, cell in
                cell.busStation.text = trips.station
                cell.busDestination.text = trips.destination
                cell.travelTime.text = trips.time
                cell.estimatedArrivalTime.text = trips.estimatedArrivalTime
            }
            .disposed(by: disposeBag)
    }
}


