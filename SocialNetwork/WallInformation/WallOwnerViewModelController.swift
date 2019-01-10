//
//  WallOwnerViewModelController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/8/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation



class WallOwnerViewModelController {
    
    var wallOwnerViewModels: [WallOwnerViewModel?] = []
    
    func viewModel(at index: Int) -> WallOwnerViewModel? {
        return wallOwnerViewModels[index]
    }
}

extension WallOwnerViewModelController {
     func initViewModels(_ owner: [ProfilesInfo?]) {
       wallOwnerViewModels = owner.map { ownerInfo in
            if let ownerInfo = ownerInfo {
                return WallOwnerViewModel(ownerInfo: ownerInfo)
            } else {
                return nil
            }
        }
    }
    
}
