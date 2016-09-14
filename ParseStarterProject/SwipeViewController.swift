//
//  SwipeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 31.08.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var currentUserId = ""
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        
        updateImage()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(SwipeViewController.wasDragged(gestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(gesture)
        
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            
            if let geoPoint = geoPoint {
                
                PFUser.current()?["location"] = geoPoint
                
                PFUser.current()?.saveInBackground()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wasDragged (gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        imageView?.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = (imageView?.center.x)! - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        imageView?.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var rejectedOrAccepted = ""
            
            if imageView?.center.x < 100 {
                
                print("chosen")
                
                rejectedOrAccepted = "accepted"
     
            } else if imageView?.center.x > self.view.bounds.width - 100 {
                
                print("not chosen")
                
                rejectedOrAccepted = "rejected"
                
                
            }
            
            if rejectedOrAccepted != "" && currentUserId != "" {
                
                PFUser.current()?.addUniqueObjects(from: [currentUserId], forKey: rejectedOrAccepted)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        
                        self.updateImage()
                        
                    }
                })
                
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            imageView?.transform = stretchAndRotation
            imageView?.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            
            
        }
        
        // print(translation)
        
    }
    
    func updateImage () {
        
        let query = PFUser.query()
        
        query?.whereKey("gender", equalTo: (PFUser.current()?["interestedGender"])!)
        query?.whereKey("interestedGender", equalTo: (PFUser.current()?["gender"])!)
        
        /*
        if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint {
            
            query?.whereKey("location", nearGeoPoint: geoPoint , withinKilometers: 100)
        }
        
        */
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let users = objects {
                    
                    for user in users {
                        
                        if let user = user as? PFUser {
                            
                            
                            self.currentUserId = user.objectId!
                            
                            if let photo = user["imageFile"] as? PFFile {
                                
                                photo.getDataInBackground(block: { (data, error) in
                                    if error != nil {
                                        
                                        print(error)
                                        
                                    } else {
                                        
                                        if let imageData = data {
                                            
                                            if let downloadedImage = UIImage(data: imageData) {
                                                
                                                self.imageView.image = downloadedImage
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                
            }
        })
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLogin" {
            
            PFUser.logOut()
        }
    }


}
