//
//  ProfileViewController.swift
//  userAuthParseFB
//
//  Created by George Gogarten on 7/6/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message:String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var email: UILabel!
    
    
    @IBOutlet weak var firstName: UITextField!
    
    
    @IBOutlet weak var lastName: UITextField!
    
    
    @IBOutlet weak var age: UITextField!
    
    
    @IBOutlet weak var sex: UITextField!
    
    
    @IBAction func logout(sender: AnyObject) {
        
        print(PFUser.currentUser())
        PFUser.logOut()
        print("logout succesful")
        print(PFUser.currentUser())
        var currentUser = PFUser.currentUser() // this will now be nil
        print(PFUser.currentUser())
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("login") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        if firstName.text == "" || lastName.text == "" || age.text == "" || sex.text == "" {
            
            displayAlert("Error in form", message: "Please fill in all fields.")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            var errorMessage = "Please try again later"
            
            var user = PFUser.currentUser()!
            user.username = username.text
            user["FirstName"] = firstName.text
            user["LastName"] = lastName.text
            user["Age"] = age.text
            user["sex"] = sex.text
            
            
            // different from video material, using signup instead of save, of the user is not there how would we save to it?
            
            user.saveInBackgroundWithBlock({ (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    // Signup successful
                    self.displayAlert("Save Succesful", message: "Please ok to continue.")
                    
                    print("Save Succesful")
                    
                    
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                        
                    }
                    
                    self.displayAlert("Save Failed", message: errorMessage)
                }
                
                
                
            })
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            // Do stuff with the user
            username.text = PFUser.currentUser()?.username
            email.text = PFUser.currentUser()?.email
            
            
        } else {
            // Show the signup or login screen
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("login") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
