//
//  File.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/30/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

struct Friends: Decodable {
    let response: FriendsInfo
    
}

struct FriendsInfo: Decodable {
    let count: Int?
    let items: [FriendItems]
    
}

struct FriendItems: Decodable {
    let id: Int?
    let first_name: String?
    let last_name: String?
    let country: FriendsCountry?
    let city: FriendsCity?
    let online: Int?
    let photo_100: String?
}

struct FriendsCountry: Decodable {
    let id: Int?
    let title: String?
}

struct FriendsCity: Decodable {
    let id: Int?
    let title: String?
}
