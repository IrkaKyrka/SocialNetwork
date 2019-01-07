//
//  GroupModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/20/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import Foundation

struct Groups: Decodable {
    let response: GroupsInfo
    
}

struct GroupsInfo: Decodable {
    let count: Int?
    let items: [Items]
}

struct Items: Decodable {
    let id: Int?
    let name: String?
    let photo_200: String?
}
