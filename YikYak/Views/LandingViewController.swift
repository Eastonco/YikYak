//
//  LandingViewController.swift
//  YikYak
//
//  Created by Connor Easton on 5/4/21.
//

import UIKit
import Foundation
import FirebaseAuth

class LandingViewController: UIViewController {

    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var lognBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        formatButtons()
        checkAuth()

        // Do any additional setup after loading the view.
    }
    
    func formatButtons(){
        signupBtn.layer.cornerRadius = 20
        signupBtn.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        signupBtn.tintColor = UIColor.white

        lognBtn.layer.borderWidth = 2
        lognBtn.layer.borderColor = UIColor.black.cgColor
        lognBtn.layer.cornerRadius = 20
        lognBtn.tintColor = UIColor.black
    }
    
    func checkAuth(){
        if let user = Auth.auth().currentUser { // user already signed in.
            let tabBarController = storyboard?.instantiateViewController(withIdentifier: "HomeTB") as! UITabBarController
            
            DispatchQueue.main.async {
                self.view.window?.rootViewController = tabBarController
                self.view.window?.makeKeyAndVisible()
            }

        }
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
