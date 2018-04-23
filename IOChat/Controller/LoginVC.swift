//
//  LoginVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var loginPressed: UIButton!
    @IBAction func loginPressed(_ sender: Any) {
        spinner.isHidden=false
        spinner.startAnimating()
        guard let userName = userNameTxt.text , userNameTxt.text != "" else {return}
        guard let pass = passTxt.text , passTxt.text != "" else {return}
        
        AuthService.instance.loginUser(email: userName, password: pass) { (success) in
            if success{
                AuthService.instance.findUserByEmail(completion: { (success) in
                    self.spinner.isHidden=true
                    self.spinner.stopAnimating()
                    if success{
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGE, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    func setupView(){
        spinner.isHidden=true
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: IOPurplePlaceholder])
        passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: IOPurplePlaceholder])
//        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
    }
}
