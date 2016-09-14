/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    // Variables
    var activityIndicator = UIActivityIndicatorView()

    // Login Oulets and Action
    @IBOutlet weak var usernameLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    
    @IBAction func login(_ sender: AnyObject) {
        
        if (usernameLoginTextField.text?.isEmpty)! || (passwordLoginTextField.text?.isEmpty)! {
            
            createAlert(title: "Login Error", message: "Please enter an username and a password")
        } else {
            
            // Login
            activateIndicator()
            
            PFUser.logInWithUsername(inBackground: usernameLoginTextField.text!, password: passwordLoginTextField.text!, block: { (user, error) in
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                
                if  error != nil {
                    
                    if let error = error as NSError? {
                        
                        self.createAlert(title: "Login Error", message: error.userInfo["error"] as! String)
                    }
                } else {
                    
                    print("user logged in")
                    
                    self.checkUser()
                }
            })
            
            
            
        }
        
        
    }
    
    // Signup Oulets and Action
    @IBOutlet weak var usernameSignupTextFiled: UITextField!
    
    @IBOutlet weak var passwordSignupTextField: UITextField!
    
    @IBAction func signup(_ sender: AnyObject) {
        if (usernameSignupTextFiled.text?.isEmpty)! || (passwordSignupTextField.text?.isEmpty)! {
            createAlert(title: "Signup Error", message: "Please enter an username and a password")
        } else {
            
            activateIndicator()
            
            let user = PFUser()
            
            user.username = usernameSignupTextFiled.text
            
            user.password = passwordSignupTextField.text
            
            let acl = PFACL()
            
            acl.getPublicWriteAccess = true
            
            acl.getPublicReadAccess = true
            
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
                    self.performSegue(withIdentifier: "showExtraDetails", sender: self)
                }
            })
        
        }
        
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    
        checkUser()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Helper Methods
    
    func checkUser () {
        
        if PFUser.current() != nil {
            
            
            if PFUser.current()!["interestedGender"] != nil && PFUser.current()!["gender"] != nil && PFUser.current()!["imageFile"] != nil {
                
                performSegue(withIdentifier: "showSwipingFromInitial", sender: self)
                
            } else {
                
                performSegue(withIdentifier: "showExtraDetails", sender: self)
            }
            
            
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func activateIndicator () {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
}
