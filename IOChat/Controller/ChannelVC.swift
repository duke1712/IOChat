//
//  ChannelVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 21/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60;
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    

}
