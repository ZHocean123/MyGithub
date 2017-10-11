//
//  RepositoryCellBuuton.swift
//  MyGithub
//
//  Created by yang on 11/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit

class RepositoryCellButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
}
