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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    // Variables
    var avatarName = "profileDefault"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden=true
        let tap = UIPanGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != ""{
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        spinner.isHidden=false
        spinner.startAnimating()
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
                            self.spinner.isHidden=true
                            self.spinner.stopAnimating()
                            if success{
                                
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGE, object: nil)

                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                
                            }
                        })
                    }
                    else{
                        
                        self.spinner.isHidden=true
                        self.spinner.stopAnimating()
                    }
                })
            }
            else{
                let alert = UIAlertController(title: "Error!!", message: "User Already Exists", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)
                self.spinner.isHidden=true
                self.spinner.stopAnimating()
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
