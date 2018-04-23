//
//  AddChannelVC.swift
//  IOChat
//
//  Created by Pritesh Patel on 23/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    @IBAction func closedModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
    }
    
    func setupViews(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap))
        bgView.addGestureRecognizer(tap)
        
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
