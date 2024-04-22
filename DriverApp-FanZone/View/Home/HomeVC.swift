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
    
    var date = ["20":"Sun","21":"Mon","22":"Tue","23":"wed","24":"Thu","25":"Fri"]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dateCell")
        binding()
    }
    
}

extension HomeVC {
    func binding() {
        let sortedDate = date.sorted(by: { $0.key < $1.key })

        Observable.just(sortedDate)
            .bind(to: dateCollectionView.rx.items(cellIdentifier: "dateCell", cellType: CollectionViewCell.self)) { index, data, cell in
                cell.dayNumber.text = data.key
                cell.dayName.text = data.value
            }
            .disposed(by: disposeBag)
    }
}

