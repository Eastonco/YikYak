//
//  HomeViewController.swift
//  YikYak
//
//  Created by Connor Easton on 4/14/21.
//

import UIKit
import Firebase
import CoreLocation

class HomeViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var karmaLabel: UIBarButtonItem!
    @IBOutlet weak var sortByToggle: UISegmentedControl!
    
    let postCollection = Firestore.firestore().collection("posts")
    let userCollection = Firestore.firestore().collection("users")
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    var posts: [Post] = []
    var sortedPosts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocation()
        
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(FetchPosts(_:)) , for: .valueChanged)
        
        karmaListener()
        FetchPosts(self)
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - CLLocation
    
    func initializeLocation(){
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("location authorized")
            startLocation()
        case .denied, .restricted:
            print("Location not Authorized")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown location Auth status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            print("location changed to authorized")
        } else {
            print("location changed to not authorized")
            locationManager.stopUpdatingLocation()
        }
    }
    
    func startLocation () {
        let status = locationManager.authorizationStatus
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error: \(error.localizedDescription)")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        var currentPost: Post!
        
         currentPost = sortedPosts[indexPath.row]
        
        cell.post = currentPost
        cell.postCollection = postCollection
        cell.userCollection = userCollection
        
        cell.body.text = currentPost.body
        
        let timestamp = currentPost.date
        let date = timestamp.dateValue()
        let currentDate = Date()
        
        let diff = Int(currentDate.timeIntervalSince1970 - date.timeIntervalSince1970)
        
        let hours = diff / 3600
        if (hours < 1){
            let minutes = (diff - hours * 3600) / 60
            cell.age.text = "\(minutes)m ago"
        } else {
            let days = hours / 24
            if (days < 1){
                cell.age.text = "\(hours)h ago"
            } else {
                cell.age.text = "\(days)d ago"
            }
        }
        
        cell.rating.text = String(currentPost.rating)
        
        return cell
    }
    
    func sortPosts() {
        let choice =  sortByToggle.selectedSegmentIndex
        
        switch choice {
        case 0:
            let sort = posts.sorted {
                return $0.date.dateValue() > $1.date.dateValue()
            }
            sortedPosts = sort

        case 1:
            let sort = posts.sorted {
                return $0.rating > $1.rating
            }
            sortedPosts = sort

        default:
            let sort = posts.sorted {
                return $0.date.dateValue() > $1.date.dateValue()
            }
            sortedPosts = sort

        }
    }
    @IBAction func toggleChanged(_ sender: Any) {
        sortPosts()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Firebase
    
    @objc func FetchPosts(_ sender: AnyObject){
        postCollection.getDocuments() { (querySnapshot, error) in
            if let err = error {
                print("Error fetching documents: \(err)")
            } else {
                self.posts = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let post = Post(dict: document.data())
                    post.id = document.documentID
                    self.posts.append(post)
                }
                self.sortPosts()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }

    func addPost(_ post: Post){
        var ref: DocumentReference?
        ref = postCollection.addDocument(data: post.toDict()) { error in
            if let err = error {
                print("Error addign document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                post.id = ref!.documentID
                self.posts.insert(post, at: 0)
                self.sortPosts()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    func karmaListener() {
        userCollection.document("\(Auth.auth().currentUser!.uid)")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                self.karmaLabel.title = "Karma: \(String(data["karma"] as! Int))"
            }
    }
    
    // MARK: - Segues
    
    @IBAction func unwindFromPostView (sender: UIStoryboardSegue) {
        if sender.identifier == "saveUnwind" {
            let postVC = sender.source as! PostViewController
            if let newPost = postVC.newPost {
                addPost(newPost)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newPostSegue") {
            let postVC = segue.destination as! PostViewController
            postVC.currentLocation = currentLocation
        }
    }
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
