//
//  GroupInformationModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/25/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

struct GroupInformation: Decodable {
    let response: [DetailsOfGroup]
    
}

struct DetailsOfGroup: Decodable {
    let id: Int?
    let name: String?
    let type: String?
    let description: String?
    let members_count: Int?
    let photo_200: String?
    let country: CountryOfGroup?
    let city: CityOfGroup?
}

struct CountryOfGroup: Decodable {
    let id: Int?
    let title: String?
    
}

struct CityOfGroup: Decodable {
    let id: Int?
    let title: String?
}
