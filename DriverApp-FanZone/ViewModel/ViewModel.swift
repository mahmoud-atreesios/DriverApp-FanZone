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
    var driverData = BehaviorRelay<[String:String]>.init(value: [:])
    
    private let db = Firestore.firestore()
    
}

extension ViewModel{
    func fetchTripsData(selectedDate: String?, tripStatus: String){
        let userID = Auth.auth().currentUser?.uid
        
        if let userID = userID {
            var query = db.collection("Trips")
                .whereField("driverID", isEqualTo: userID)
                .whereField("tripStatus", isEqualTo: tripStatus)
            
            if let selectedDate = selectedDate {
                query = query.whereField("date", isEqualTo: selectedDate)
            }
            
            query.getDocuments { trips, error in
                if let error = error {
                    print("Error getting trips data \(error.localizedDescription)")
                } else {
                    guard let documents = trips?.documents else {
                        print("No documents")
                        return
                    }
                        
                        let tripsData = documents.compactMap { document -> TripsDataModel? in
                            let data = document.data()
                            let tripID = document.documentID
                            
                            guard let busNumber = data["busNumber"] as? String,
                                  let date = data["date"] as? String,
                                  let destination = data["destination"] as? String,
                                  let driverID = data["driverID"] as? String,
                                  let price = data["price"] as? String,
                                  let station = data["station"] as? String,
                                  let tripStatus = data["tripStatus"] as? String,
                                  let availableSeats = data["availableSeats"] as? Int,
                                  let driverPrice = data["driverPrice"] as? String,
                                  let time = data["time"] as? String else {
                                return nil
                            }
                            
                            return TripsDataModel(tripID: tripID, busNumber: busNumber, date: date, destination: destination, driverID: driverID, price: price, station: station, time: time, tripStatus: tripStatus, availableSeats: availableSeats, driverPrice: driverPrice)
                        }
                        
                        self.tripsData.accept(tripsData)
                    }
                }
        }
    }
}

extension ViewModel{
    func updateTripStatus(tripID: String, newStatus: String) {
        db.collection("Trips").document(tripID).updateData(["tripStatus": newStatus]) { error in
            if let error = error {
                print("Error updating trip status: \(error.localizedDescription)")
            } else {
                print("Trip status updated successfully")
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
    func updateFanBusTicketStatus(fanid: String, busNumber: String, travelDate: String, station: String, destination: String, newTicketStatus: String) {
        db.collection("Bus_Tickets")
            .whereField("busNumber", isEqualTo: busNumber)
            .whereField("travelDate", isEqualTo: travelDate)
            .whereField("busStation", isEqualTo: station)
            .whereField("stadiumDestination", isEqualTo: destination)
            .whereField("userID", isEqualTo: fanid)
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

extension ViewModel{
    func fetchDriverData(){
        if let userID = Auth.auth().currentUser?.uid{
            db.collection("Driver").document(userID)
                .getDocument { snapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                        return
                    }
                    
                    guard let snapshot = snapshot else {
                        print("No documents found")
                        return
                    }
                    
                    if let data = snapshot.data() as? [String: String] {
                        self.driverData.accept(data)
                    } else {
                        print("Document data was empty.")
                    }
                }
        }
    }
}
