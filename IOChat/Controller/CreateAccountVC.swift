//
//  CreateAccountVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    // Variables
    let avatarName = "profileDefault"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let userName = userNameTxt.text , userNameTxt.text != "" else {
            return
        }
        guard let email = emailTxt.text , emailTxt.text != "" else {
            return
        }
        guard let pass = passTxt.text , passTxt.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success{
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: userName, email: email, avatarName: self.avatarName, completion: { (success) in
                            if success{
                                print(UserDataService.instance.name)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    @IBAction func pickAvatarPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    @IBAction func closedPressed(_ sender: UIButton) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
