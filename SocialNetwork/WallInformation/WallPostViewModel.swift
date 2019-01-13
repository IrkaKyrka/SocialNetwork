//
//  WallViewModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/8/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation


struct WallPostViewModel{
    
    let ownerId: Int
    let historyOwnerId: Int?
    let ownerDatePost: Int?
    let historyOwnerDatePost: Int?
    let postText: String?
    let postImage: String?
    let postVideoImage: String?
    let attachmentType: String?
    let videoId: String?
    
    init(wallItem: WallItems) {
        if let image = wallItem.copy_history?[0].attachments?[0].photo?.sizes?[3].url{
            postImage = image
        } else{
            postImage = wallItem.attachments?[0].photo?.sizes?[3].url
        }
        if let video = wallItem.copy_history?[0].attachments?[0].video{
            postVideoImage = video.photo_320
            videoId = "\(video.owner_id!)_\(video.id!)"
        } else{
            postVideoImage = wallItem.attachments?[0].video?.photo_320
            videoId = "\(wallItem.attachments?[0].video?.owner_id!)_\(wallItem.attachments?[0].video?.id!)"
        }
        ownerDatePost = wallItem.date
        historyOwnerDatePost = wallItem.copy_history?[0].date
        if let text = wallItem.copy_history?[0].text {
            postText = text
        } else {
            postText = wallItem.text
        }
        ownerId = wallItem.owner_id!
        historyOwnerId = wallItem.copy_history?[0].owner_id
        if let type = wallItem.copy_history?[0].attachments?[0].type{
            attachmentType = type
        }else{
            attachmentType =  wallItem.attachments?[0].type
        }
    }
}




