//
//  Post.swift
//  YikYak
//
//  Created by Connor Easton on 5/2/21.
//

import Foundation
import Firebase
import CoreLocation
import FirebaseAuth


class Post {
    var body: String
    var date: Firebase.Timestamp
    var location: Firebase.GeoPoint
    var rating: Int
    var userID: String
    var id: String?
    
    init(body: String, location: CLLocation){
        let coord = location.coordinate
        
        self.body = body
        self.date = Firebase.Timestamp()
        self.location = GeoPoint(latitude: coord.latitude, longitude: coord.longitude)
        self.rating = 0
        self.userID = Auth.auth().currentUser!.uid
    }
    
    init(dict: [String: Any]){
        self.body = dict["body"] as! String
        self.date = dict["date"] as! Firebase.Timestamp
        self.location = dict["location"] as! GeoPoint
        self.rating = dict["rating"] as! Int
        self.userID = dict["userID"] as! String
    }
    
    func toDict() -> [String: Any] {
        return ["body": body, "date": date, "location": location, "rating": rating, "userID": userID]
    }
    
}
