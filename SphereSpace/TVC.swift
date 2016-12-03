//
//  TVC.swift
//  SphereSpace
//
//  Created by Victor Shurapov on 11/14/16.
//  Copyright © 2016 Victor Shurapov. All rights reserved.
//
import UIKit
import QuartzCore
import Firebase
import FirebaseStorageUI

class TVC: UITableViewController {
    
    var databaseRef: FIRDatabaseReference!
    var storage: FIRStorage!
    var posts = [File]()
    
    
    
    // MARK: Hardcoded items
    
    
    let imagesArray = [UIImage(named: "thumbNail1")!, UIImage(named: "thumbNail2")!, UIImage(named: "thumbNail3")!]
    var imageStringsArray = [Data]()
    
    // Returns the data for the specified image in PNG format (->Data)
    func image2Data(imagesArray: [UIImage]) {
        for i in imagesArray {
            let pngRep = UIImagePNGRepresentation(i)
            imageStringsArray.append(pngRep!)
        }
    }
    
    let titleV = "Burj Khalifa Base Jump 360°"
    let messageV = "Check out this uncut cockpit view footage of guys taking a giant leap from the pinnacle of the 828-metre-high Burj Khalifa."
    
    
    
    
    // MARK: VIEW_DID_LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        storage = FIRStorage.storage()
        image2Data(imagesArray: imagesArray)
        
        //uploadImageToFirebaseStorage(data: imageStringsArray)
        addNewStream()
    }
    
    
    // MARK: Adding new streams
    func addNewStream() {
        databaseRef.child("Test").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            let value = snapshot.value as? [String: AnyObject]
            let imageUrl = value?["thumbnail"] as! String
            let title = value?["title"] as! String
            let message = value?["message"] as! String
            
            self.posts.insert(File(thumbnail: imageUrl, title: title, message: message), at: 0)
            self.tableView.reloadData()
        })
    }
    
    // MARK: Post to FIR Storage
    func uploadImageToFirebaseStorage(data: [Data]) {
        
        for (index, value) in data.enumerated() {
            
            let imageStorageRef = storage.reference(withPath: "images/thumbnail\(index).png")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/png"
            let uploadTask = imageStorageRef.put(value, metadata: uploadMetadata, completion: { (metadata, error) in
                
                if error != nil {
                    print("I received an error! \(error?.localizedDescription)")
                } else {
                    print("Upload complete! Here's some metadata! \(metadata)")
                    
                    let downloadURL = metadata!.downloadURL()?.absoluteString
                    // This can be stored in the Firebase Realtime Database
                    // It can also be used by image loading libraries like SDWebImage
                    self.post(title: self.titleV, message: self.messageV, image: downloadURL!)
                }
            })
        }
    }
    
    // MARK: Post to Database
    func post(title: String, message: String, image: String) {
        let post = ["title": title, "message": message, "thumbnail": image] as [String : Any]
        databaseRef.child("Test").childByAutoId().setValue(post)
    }
    
    // MARK: TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FeedTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = posts[indexPath.row].title
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = posts[indexPath.row].message
        
        let imageRefString = posts[indexPath.row].thumbnail
        let url = URL(string: imageRefString)
        cell.thumbNailImage.sd_setImage(with: url)
        
        return cell
    }
}



//let imageStorageRef = storage.reference(withPath: "images/thumbnail.png")
//let uploadMetadata = FIRStorageMetadata()
//uploadMetadata.contentType = "image/png"
//let uploadTask = imageStorageRef.put(data, metadata: uploadMetadata, completion: { (metadata, error) in
//
//    if error != nil {
//        print("I received an error! \(error?.localizedDescription)")
//    } else {
//        print("Upload complete! Here's some metadata! \(metadata)")
//
//        let downloadURL = metadata!.downloadURL()?.absoluteString
//        // This can be stored in the Firebase Realtime Database
//        // It can also be used by image loading libraries like SDWebImage
//        self.post(title: self.titleV, message: self.messageV, image: downloadURL!)
//    }
//})



////////////
//cell.labelllll.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)

//cell.labelllll.backgroundColor?.withAlphaComponent(<#T##alpha: CGFloat##CGFloat#>)
//cell.labelllll.layer.cornerRadius = 10
//cell.labelllll.clipsToBounds = true

///////

//let userID = FIRAuth.auth()?.currentUser?.uid


//// Initialization of UIImage from projet's file
//let thumbnailImage = UIImage(named: "thumbNail3")
//// Returns the data for the specified image in PNG format (->Data)
//let imageData = UIImagePNGRepresentation(thumbnailImage!)!
//// Returns a Base-64 encoded string.
//let myBase64ImageDataString = imageData.base64EncodedString() as NSString
