//
//  WallInformationModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/27/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

struct Wall: Decodable {
    let response: WallInfo
}

struct WallInfo: Decodable {
    let count: Int?
    let items: [WallItems]
    let profiles: [ProfilesInfo]
    let groups: [ProfileOfGroups]
}

struct WallItems: Decodable {
    let id: Int?
    let from_id: Int?
    let owner_id: Int?
    let date: Int?
    let post_type: String?
    let text: String?
    let copy_history: [CopyHistory]?
}

struct CopyHistory: Decodable {
    let id: Int?
    let owner_id: Int?
    let date: Int?
    let post_type: String?
    let text: String?
    let attachments: [PostAttachments]?
}

struct PostAttachments: Decodable {
    let type: String?
    let photo: PostFoto?
    let video: PostVideo?
}

struct PostFoto: Decodable {
    let id: Int?
    let sizes: [SizeOfFoto]?
}

struct PostVideo: Decodable {
    let id: Int?
    let title: String?
    let photo_320: String?
}

struct SizeOfFoto: Decodable {
    let type: String?
    let url: String?
    let width: Int?
    let height: Int?
}

struct ProfilesInfo: Decodable {
    let id: Int?
    let first_name: String?
    let last_name: String?
    let photo_100: String?
}

struct ProfileOfGroups: Decodable {
    let id: Int?
    let name: String?
    let photo_100: String?
}
