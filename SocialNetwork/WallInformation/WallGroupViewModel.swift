//
//  WallGroupViewModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/9/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation

struct WallGroupViewModel {
    let groupId: Int?
    let groupImage: String?
    let groupName: String
    
    
    init(groupInfo: ProfileOfGroups){
        groupId = groupInfo.id
        groupImage = groupInfo.photo_50
        groupName = groupInfo.name!
    }
    
}
