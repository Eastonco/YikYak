//
//  PostTableViewCell.swift
//  YikYak
//
//  Created by Connor Easton on 5/3/21.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {

    
    var post: Post!
    var postCollection: CollectionReference!
    var userCollection: CollectionReference!
    var voteStatus = 0
    
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var age: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func upvotePressed(_ sender: Any) {
        if(voteStatus == 0){
            voteStatus = 1
            changeRating(adjust: 1)
        } else if(voteStatus == -1){
            voteStatus = 1
            changeRating(adjust: 2)
        } else {
            voteStatus = 0
            changeRating(adjust: -1)
        }
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        if(voteStatus == 0){
            voteStatus = -1
            changeRating(adjust: -1)
        } else if(voteStatus == 1){
            voteStatus = -1
            changeRating(adjust: -2)
        } else {
            voteStatus = 0
            changeRating(adjust: 1)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeRating(adjust:Int){
        print(post.id!)
        let postRef = postCollection.document("\(post.id!)")
        
        let newPostRate = Int(rating.text!)! + adjust
        rating.text = String(newPostRate)
        
        postRef.updateData(["rating": newPostRate]) { err in
            if let err = err {
                print("Error updating post document: \(err)")
            } else {
                print("Post document successfully updated")
            }
        }
        
        let userRef = userCollection.document("\(post.userID)")
        var newKarma = 0

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                newKarma = data!["karma"] as! Int + adjust
                
                userRef.updateData(["karma": newKarma]) { err in
                    if let err = err {
                        print("Error updating user document: \(err)")
                    } else {
                        print("User document successfully updated")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        
        

    }
}
