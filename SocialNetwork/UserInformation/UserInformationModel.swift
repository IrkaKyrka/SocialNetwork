//
//  UserInformationModel.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/26/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

struct UserInformation: Decodable {
    let response: [DetailsOfUser]
    
}

struct DetailsOfUser: Decodable {
    let id: Int?
    let first_name: String?
    let last_name: String?
    let sex: Int?
    let bdate: String?
    let photo_200: String?
    let country: CountryOfUser?
    let city: CityOfUser?
    let online: Int?
}

struct CountryOfUser: Decodable {
    let id: Int?
    let title: String?
    
}

struct CityOfUser: Decodable {
    let id: Int?
    let title: String?
}


