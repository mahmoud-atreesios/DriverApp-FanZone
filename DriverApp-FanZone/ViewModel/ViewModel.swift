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

class ViewModel{
    
    var selectedIndexPath = BehaviorRelay<IndexPath?>(value: IndexPath(item: 0, section: 0))
    var tripsData = BehaviorRelay<[TripsDataModel]>.init(value: [])
    var bookedFans = BehaviorRelay<[[String:String]]>.init(value: [])
    
    private let db = Firestore.firestore()
    
}

extension ViewModel{
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

extension ViewModel{
    func BookedFans(busNumber: String, travelDate: String, station: String, destination: String){
        db.collection("Bus_Tickets")
            .whereField("busNumber", isEqualTo: busNumber)
            .whereField("travelDate", isEqualTo: travelDate)
            .whereField("busStation", isEqualTo: station)
            .whereField("stadiumDestination", isEqualTo: destination)
            .whereField("ticketStatus", isEqualTo: "Activated")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No documents found")
                    return
                }
                
                let fetchedBookedFans = snapshot.documents.compactMap { $0.data() as? [String: String] }
                
                self.bookedFans.accept(fetchedBookedFans)
            }
        
    }
}

extension ViewModel {
    func updateFanBusTicketStatus(busNumber: String, travelDate: String, station: String, destination: String, newTicketStatus: String) {
        db.collection("Bus_Tickets")
            .whereField("busNumber", isEqualTo: busNumber)
            .whereField("travelDate", isEqualTo: travelDate)
            .whereField("busStation", isEqualTo: station)
            .whereField("stadiumDestination", isEqualTo: destination)
            .whereField("ticketStatus", isEqualTo: "Activated")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("No documents found")
                    return
                }

                for document in snapshot.documents {
                    let documentRef = self.db.collection("Bus_Tickets").document(document.documentID)
                    documentRef.updateData(["ticketStatus": newTicketStatus]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
    }
}

