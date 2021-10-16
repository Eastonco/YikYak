//
//  PostViewController.swift
//  YikYak
//
//  Created by Connor Easton on 5/2/21.
//

import UIKit
import CoreLocation


class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    var newPost: Post?
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        textView.text = "Share something cool!"
        textView.textColor = UIColor.lightGray
        
        self.textView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.view.endEditing(true)
        performSegue(withIdentifier: "cancelUnwind", sender: self)
    }
    
    @IBAction func PostPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let body = textView.text {
            if currentLocation != nil {
                self.newPost = Post(body: body, location: currentLocation!)
            }
        }
        performSegue(withIdentifier: "saveUnwind", sender: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share something cool!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
