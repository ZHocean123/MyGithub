//
//  RepositoryTableViewCell.swift
//  MyGithub
//
//  Created by yang on 11/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var starsButton: UIButton!
    @IBOutlet weak var forksButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
