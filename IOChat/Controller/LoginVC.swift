//
//  LoginVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
}
