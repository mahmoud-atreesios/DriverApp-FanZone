//
//  ViewModel.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/04/2024.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel{
    let date = BehaviorRelay<[String:String]>(value: ["20":"Sun","21":"Mon","22":"Tue","23":"wed","24":"Thu","25":"Fri"])
    var selectedIndexPath = BehaviorRelay<IndexPath?>(value: IndexPath(item: 0, section: 0))
}
