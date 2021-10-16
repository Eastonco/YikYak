//
//  LoginViewController.swift
//  YikYak
//
//  Created by Connor Easton on 5/4/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatButtons()
        
        

        

        // Do any additional setup after loading the view.
    }
    
    func formatButtons(){
        loginBtn.layer.cornerRadius = 20
        loginBtn.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        loginBtn.tintColor = UIColor.white
        
        errorMessage.text = nil

    }
    
    func validateFields() -> String? {
        if  (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text == "") {
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let error = validateFields()
        if (error != nil){
            errorMessage.text = error
        } else {
        
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    // Couldn't sign in
                    self.errorMessage.text = error!.localizedDescription
                }
                else {
                    self.setHomeVC()
                }
            }
        }
    }
    
    func setHomeVC(){
        
    
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "HomeTB") as! UITabBarController
        
        view.window?.rootViewController = tabBarController
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
