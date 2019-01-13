//
//  VideoModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/12/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation


struct Video: Decodable {
    let response: Response
}

struct Response: Decodable {
    let items: [VideoItems]
}

struct VideoItems: Decodable {
    let id: Int
    let player: String
    let files: Files
}

struct Files: Decodable {
    let mp4_240: String?
    let mp4_360: String?
    let mp4_480: String?
    let mp4_720: String?
}
