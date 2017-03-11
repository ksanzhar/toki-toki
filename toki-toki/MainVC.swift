//
//  MainVC.swift
//  toki-toki
//
//  Created by Sanzhar Kozhahmetov on 3/1/17.
//  Copyright © 2017 Sanzhar Kozhahmetov. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class MainVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print ("Unable to login in facebook - \(error)")
            } else if result?.isCancelled == true {
                print ("User canceled facebook login")
            } else {
                print ("Facebook login")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print ("Unable to login in firebase - \(error)")
            } else {
                print("Firebase login")
            }
        })
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print ("Firebase login")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print ("Unable to login in firebase")
                        } else {
                            print ("Firebase login")
                        }
                    })
                }
            })
        }
    }
}

