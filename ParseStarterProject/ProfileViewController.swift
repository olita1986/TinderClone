//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 26.08.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Variables
    var activityIndicator = UIActivityIndicatorView()
    var gender = "male"
    var interestedGender = "male"
    let arrayGirls = ["http://static9.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG","https://s-media-cache-ak0.pinimg.com/564x/9c/5e/86/9c5e86be6bf91c9dea7bac0ab473baa4.jpg","http://cliparts.co/cliparts/6ip/5kk/6ip5kkaKT.jpg"]
    
    var counter = 0

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ownGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    
    
    @IBAction func updateImage(_ sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImageView.image = image
            
            //postImage = image
            
            //print("this is the new image \(postImage.size.height)")
        } else {
            
            print("there was a problem")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateProfile(_ sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let user = PFUser.current()
        
        let imageData = UIImagePNGRepresentation(profileImageView.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        user?["imageFile"] = imageFile
        
        user?["gender"] = gender
        
        user?["interestedGender"] = interestedGender
        
        user?.saveInBackground(block: { (success, error) in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            if error != nil {
                
                print(error)
            } else {
                
                //self.createAlert(title: "Profile Updated", message: "Your profile has been updated!")
                
                self.performSegue(withIdentifier: "showSwiping", sender: self)
            }
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ownGenderSwitch.addTarget(self, action: #selector(ProfileViewController.chooseOwnGender(switchState:)), for: UIControlEvents.valueChanged)
        
        interestedGenderSwitch.addTarget(self, action: #selector(ProfileViewController.chooseInterestedGender(switchState:)), for: UIControlEvents.valueChanged)
        
        if let gender = PFUser.current()?["gender"] as? String {
            
            if gender == "male" {
                ownGenderSwitch.setOn(false, animated: false)
            } else {
                
                ownGenderSwitch.setOn(true, animated: false)
            }
            
        }
        
        if let interestedGender = PFUser.current()?["interestedGender"] as? String {
            
            if interestedGender == "male" {
                interestedGenderSwitch.setOn(false, animated: false)
            } else {
                
                interestedGenderSwitch.setOn(true, animated: false)
            }
            
        }
        
        if let photo = PFUser.current()?["imageFile"] as? PFFile {
            
            photo.getDataInBackground(block: { (data, error) in
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let imageData = data {
                        
                        if let downloadedImage = UIImage(data: imageData) {
                            
                            self.profileImageView.image = downloadedImage
                        }
                    }
                }
            })
            
            
        }
        
        
        
        //createUsers(array: arrayGirls)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseOwnGender (switchState: UISwitch) {
        
        if switchState.isOn {
            
            gender = "female"
            
        } else {
            
            gender = "male"
        }
        
        print(gender)
    }
    
    func chooseInterestedGender (switchState: UISwitch) {
        
        if switchState.isOn {
            
            interestedGender = "female"
            
        } else {
            
            interestedGender = "male"
        }
        
        print(interestedGender)
    }
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createUsers (array: [String]) {
        
        for url in array {
            
             counter += 1
            
            let url = URL(string: url)!
            
            do {
                
                let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "image.png", data: data)
                
                let user = PFUser()
                
                user.username = String(counter)
                
                user.password = "12345"
                
                user["gender"] = "female"
                
                user["interestedGender"] = "male"
                
                user["imageFile"] = imageFile
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    
                    if error != nil {
                        
                        if let error = error as NSError? {
                            
                            self.createAlert(title: "Signup Error", message: error.userInfo["error"] as! String)
                        }
                        
                    } else {
                        
                        print("user signed up")
                        
                    }
                })
                
                
                
            } catch  {
                
            }
            
            
            
            
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
