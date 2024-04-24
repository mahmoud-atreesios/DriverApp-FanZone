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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dateCell")
        binding()
    }
    
}

extension HomeVC {
    func binding() {
        
        viewModel.date
            .asObservable()
            .map{$0.sorted(by: { $0.key < $1.key })}
            .bind(to: dateCollectionView.rx.items(cellIdentifier: "dateCell", cellType: CollectionViewCell.self)) { index, data, cell in
                cell.dayNumber.text = data.key
                cell.dayName.text = data.value
                cell.backgroundColor = self.viewModel.selectedIndexPath.value == IndexPath(item: index, section: 0) ? UIColor.lightGray : UIColor.white
            }
            .disposed(by: disposeBag)
        
        dateCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print("Cell tapped at index: \(indexPath.item)")
                // da l hastakhdmo 3shan a3mal beh search fe l db 3shan agyb l trips l fy l youm da bs
                guard let sortedDate = self?.viewModel.date.value.sorted(by: { $0.key < $1.key }) else { return }
                let selectedDateKey = sortedDate[indexPath.item].key
                print("Selected Date Key: \(selectedDateKey)")

                self?.viewModel.selectedIndexPath.accept(indexPath)
                self?.dateCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

