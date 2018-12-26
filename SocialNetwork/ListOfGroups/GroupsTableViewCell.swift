//
//  GroupTableViewCell.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/20/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameOfGroup: UILabel!
    @IBOutlet weak var imageOfGroup: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
}
