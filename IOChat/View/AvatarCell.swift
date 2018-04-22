//
//  AvatarCell.swift
//  IOChat
//
//  Created by Pritesh Patel on 22/04/18.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit
 class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configureCell(index: Int){
        avatarImg.image = UIImage(named: "dark\(index)")
        self.layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    func setupView(){
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
