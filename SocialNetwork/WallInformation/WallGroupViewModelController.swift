//
//  WallGroupViewModelController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/9/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation

class WallGroupViewModelController {
    
    
    var wallGroupViewModels: [WallGroupViewModel?] = []
    
    var viewModelsCount: Int {
        return wallGroupViewModels.count
    }
    
    func viewModel(at index: Int) -> WallGroupViewModel? {
        return wallGroupViewModels[index]
    }
    
    func initViewModels(_ group: [ProfileOfGroups?]) {
        wallGroupViewModels = group.map { groupInfo in
            if let groupInfo = groupInfo {
                return WallGroupViewModel(groupInfo: groupInfo)
            } else {
                return nil
            }
        }
    }
    
}
