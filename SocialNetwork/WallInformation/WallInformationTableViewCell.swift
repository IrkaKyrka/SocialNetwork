//
//  WallInformationTableViewCell.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/27/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

class WallInformationTableViewCell: UITableViewCell {
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerDatePost: UILabel!
    
    @IBOutlet weak var historyOwnerImage: UIImageView!
    @IBOutlet weak var historyOwnerName: UILabel!
    @IBOutlet weak var historyOwnerDatePost: UILabel!
    
    @IBOutlet weak var historyPostText: UILabel!
    @IBOutlet weak var historyPostImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state

    }
}
