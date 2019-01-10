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
    
    
    static let defaultImage = UIImage(named: "Image")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        ownerImage.setRoundedImage(WallInformationTableViewCell.defaultImage)
    }
    
    func configure(_ viewOwnerModel: WallOwnerViewModel, _ viewPostModel: WallPostViewModel, _ viewGroupModel: WallGroupViewModel) {
        
        ownerName.text = viewOwnerModel.ownerName
        ownerDatePost.text = String(viewPostModel.ownerDatePost!)
        
        isUserInteractionEnabled = false  // Cell selection is not required for this sample
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        ownerImage.setRoundedImage(WallInformationTableViewCell.defaultImage)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state

    }
}
