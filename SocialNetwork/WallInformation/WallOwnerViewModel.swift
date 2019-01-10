//
//  WallOwnerViewModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/8/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation

struct WallOwnerViewModel {
    let ownerId: Int?
    let ownerImage: String?
    let ownerName: String
    
    
    init(ownerInfo: ProfilesInfo){
        ownerId = ownerInfo.id
        ownerImage = ownerInfo.photo_50
        ownerName = "\(ownerInfo.first_name!) \(ownerInfo.last_name!)"
    }
    
}
