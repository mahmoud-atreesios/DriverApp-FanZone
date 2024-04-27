//
//  ViewModel.swift
//  DriverApp-FanZone
//
//  Created by Mahmoud Mohamed Atrees on 22/04/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class HomeViewModel{
    
    private let db = Firestore.firestore()
    
    var tripsData = BehaviorRelay<[TripsDataModel]>.init(value: [])
    var selectedIndexPath = BehaviorRelay<IndexPath?>(value: IndexPath(item: 0, section: 0))
}

extension HomeViewModel{
    func fetchTripsData(selectedDate: String){
        let userID = Auth.auth().currentUser?.uid
        
        if let userID = userID{
            db.collection("Trips")
                .whereField("driverID", isEqualTo: userID)
                .whereField("date", isEqualTo: selectedDate)
                .getDocuments { trips, error in
                    if let error = error {
                        print("Error getting trips data \(error.localizedDescription)")
                    } else {
                        guard let documents = trips?.documents else {
                            print("No documents")
                            return
                        }
                        
                        let tripsData = documents.compactMap { document -> TripsDataModel? in
                            let data = document.data()
                            // Parse the data and create a TripsDataModel object
                            guard let busNumber = data["busNumber"] as? String,
                                  let date = data["date"] as? String,
                                  let destination = data["destination"] as? String,
                                  let driverID = data["driverID"] as? String,
                                  let estimatedArrivalTime = data["estimatedArrivalTime"] as? String,
                                  let price = data["price"] as? String,
                                  let station = data["station"] as? String,
                                  let time = data["time"] as? String else {
                                return nil
                            }
                            
                            return TripsDataModel(busNumber: busNumber, date: date, destination: destination, driverID: driverID, estimatedArrivalTime: estimatedArrivalTime, price: price, station: station, time: time)
                        }
                        
                        self.tripsData.accept(tripsData)
                    }
                }
        }
    }
}
