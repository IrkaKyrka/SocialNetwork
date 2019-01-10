//
//  WallViewModelController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/8/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation

class WallPostViewModelController {
    
    
    var wallPostViewModels: [WallPostViewModel?] = []
    
    var viewModelsCount: Int {
        return wallPostViewModels.count
    }
    
    func viewModel(at index: Int) -> WallPostViewModel? {
        return wallPostViewModels[index]
    }
    
    func initViewModels(_ posts: [WallItems?]) {
        wallPostViewModels = posts.map { wallItem in
            if let wallItem = wallItem {
                return WallPostViewModel(wallItem: wallItem)
            } else {
                return nil
            }
        }
    }
    
}

