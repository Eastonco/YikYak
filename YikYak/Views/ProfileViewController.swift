//
//  ProfileViewController.swift
//  YikYak
//
//  Created by Connor Easton on 4/14/21.
//

import UIKit
import MapKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userIdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid{
            userIdLabel.text = "UserID: \(uid)"
        } else {
            userIdLabel.text = "UserID: ?"
        }
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        try? Auth.auth().signOut()
        
        let landingController = storyboard?.instantiateViewController(withIdentifier: "LandingNC") as! UINavigationController
        view.window?.rootViewController = landingController
        view.window?.makeKeyAndVisible()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
