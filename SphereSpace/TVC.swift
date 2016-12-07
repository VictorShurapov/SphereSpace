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
    var posts = [Content4Post]()

    
    
    
    // MARK: Hardcoded items
    
    var headerArray = ["Virtual experience of solitary confinement", "Burj Khalifa Base Jump 360°", "360° Video - Virtual Reality From Your Phone!"]

    var footerArray = ["Take the 360 degree video experience of solitary confinement in US prisons", "Check out this uncut cockpit view footage of guys taking a giant leap from the pinnacle of the 828-metre-high Burj Khalifa.", "Welcome to the world of 360 video! It's virtual reality without needing goggles."]
    
    let imagesArray = [UIImage(named: "thumbNail3")!, UIImage(named: "thumbNail2")!, UIImage(named: "thumbNail1")!]
    
    var image2DataArray = [Data]()
    
    // Returns the data for the specified image in PNG format (->Data)
    func image2Data(imagesDataArray: [UIImage]) {
        for i in imagesArray {
            let pngRep = UIImagePNGRepresentation(i)
            image2DataArray.append(pngRep!)
        }
    }
    
    // MARK: VIEW_DID_LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        storage = FIRStorage.storage()
        //image2Data(imagesDataArray: imagesArray)
        
        //uploadImageToFirebaseStorage(data: image2DataArray)
        settingUserPic()

        addNewStream()
        
        
        }
    
    // MARK: Adding new streams
    func addNewStream() {
        databaseRef.child("Test").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            let value = snapshot.value as? [String: AnyObject]
            let imageUrl = value?["thumbnail"] as! String
            let text4Header = value?["header"] as! String
            let text4Footer = value?["footer"] as! String
            
            self.posts.insert(Content4Post(header: text4Header, footer: text4Footer, thumbnail: imageUrl), at: 0)
            self.tableView.reloadData()
        })
    }
    
    // MARK: Post to FIR Storage
    func uploadImageToFirebaseStorage(data: [Data]) {
        
        for (index, value) in data.enumerated() {
            
            let imageStorageRef = storage.reference(withPath: "images/thumbnail\(index).png")
            let uploadMetadata = FIRStorageMetadata()
            uploadMetadata.contentType = "image/png"
            _ = imageStorageRef.put(value, metadata: uploadMetadata, completion: { (metadata, error) in
                
                if error != nil {
                    print("I received an error! \(error?.localizedDescription)")
                } else {
                    print("Upload complete! Here's some metadata! \(metadata)")
                    
                    let downloadURL = metadata!.downloadURL()?.absoluteString
                    // This can be stored in the Firebase Realtime Database
                    // It can also be used by image loading libraries like SDWebImage
                    self.post(header: self.headerArray[index], footer: self.footerArray[index], thumbnail: downloadURL!)
                }
            })
        }
    }
    
    // MARK: Post to Database
    func post(header: String, footer: String, thumbnail: String) {
        let post = ["header": header, "footer": footer, "thumbnail": thumbnail] as [String : Any]
        databaseRef.child("Test").childByAutoId().setValue(post)
    }
    
    // MARK: TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FeedTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = posts[indexPath.row].header
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = posts[indexPath.row].footer
        
        let imageRefString = posts[indexPath.row].thumbnail
        let url = URL(string: imageRefString!)
        cell.thumbNailImage.sd_setImage(with: url)
        
        return cell
    }
    
    
    // MARK: Setting UserPic for RightBarButtonItem
    
    func settingUserPic() {
        
        var image = UIImage(named: "cutmypic")
        image = image?.withRenderingMode(.alwaysOriginal)
    
        let myBtn = UIButton()
        myBtn.setImage(image!, for: .normal)
        myBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        myBtn.addTarget(self, action: #selector(self.smile), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myBtn)
    }
    
    func smile() {
        print("Smile")
    }
}
//let userID = FIRAuth.auth()?.currentUser?.uid
