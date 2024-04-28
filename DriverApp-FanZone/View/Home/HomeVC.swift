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
    
    var noTripsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nn"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()
    var dates: [(date: Date, display: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dateCell")
        tripsTableView.register(UINib(nibName: "TripsTableViewCell", bundle: nil), forCellReuseIdentifier: "tripsCell")
        viewModel.fetchTripsData(selectedDate: todayDate())
        bindingDateCollectionViewToViewModel()
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
    func bindingDateCollectionViewToViewModel() {
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
                dates.append((date: date, display: displayDate))
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
            .subscribe(onNext: { [weak self] trips in
                if trips.isEmpty {
                    self?.setNotTodayImageView()
                    self?.tripsTableView.isHidden = true
                    self?.noTripsImageView.isHidden = false
                } else {
                    self?.tripsTableView.isHidden = false
                    self?.noTripsImageView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.tripsData
            .asObservable()
            .bind(to: tripsTableView.rx.items(cellIdentifier: "tripsCell", cellType: TripsTableViewCell.self)) { index, trips, cell in
                cell.busStation.text = trips.station
                cell.busDestination.text = trips.destination
                cell.travelTime.text = trips.time
                cell.estimatedArrivalTime.text = trips.estimatedArrivalTime
                print("\(self.viewModel.tripsData.value)")
            }
            .disposed(by: disposeBag)
    }
}


extension HomeVC{
    func setNotTodayImageView(){
        // Add noTripsImageView to the view
        view.addSubview(noTripsImageView)

        noTripsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTripsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTripsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200), // 100 points from the bottom
            noTripsImageView.widthAnchor.constraint(equalToConstant: 200), // Adjust width as needed
            noTripsImageView.heightAnchor.constraint(equalToConstant: 200) // Adjust height as needed
        ])
    }
}
