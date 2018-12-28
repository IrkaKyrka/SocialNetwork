//
//  UserInformationViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/26/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class UserInformationViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthdayAndPlace: UILabel!
    @IBOutlet weak var isOnline: UILabel!
    
    @IBOutlet weak var getListOfGroups: UIButton!
    @IBOutlet weak var getListOfFriends: UIButton!
    
    var userId = 0
    final let token = ""
    
    var userInformation = [DetailsOfUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getInformationUser()
       
    }
    
    private func getInformationUser() {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/users.get"
        urlComponents.query = "user_ids=\(userId)&fields=sex,bdate,city,country,place,photo_200,online&extended=true&access_token=\(token)&v=5.92"
        
        guard let url = urlComponents.url else { return }
        
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do{
                let downloadedInformationOfUser = try JSONDecoder().decode(UserInformation.self, from: data)
                self.userInformation = downloadedInformationOfUser.response
                
                DispatchQueue.main.async {
                    if let jsonFistName = self.userInformation[0].first_name,
                        let jsonLastName = self.userInformation[0].last_name{
                        self.name.text = "\(jsonFistName) \(jsonLastName)"
                    }
//                    let date = Date()
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "dd.m.yyyy"
//                    let resultDate = formatter.String(from: date)
                    guard let jsonBirthday = self.userInformation[0].bdate else { return }
                    guard let jsonCountry = self.userInformation[0].country?.title else { return }
                    guard let jsonCity = self.userInformation[0].city?.title else { return }
                    self.birthdayAndPlace.text = "\(jsonBirthday) \(jsonCountry), \(jsonCity)"
                    self.isOnline.text = self.userInformation[0].online! == 0 ? "Offline" : "Online"
                }
                
                if let imageURL = URL(string: self.userInformation[0].photo_200!){
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: imageURL)
                        if let data = data {
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.image.image = image
                            }
                        }
                    }
                }
                
            }catch let error {
                print(error)
        }
        }.resume()
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListOfGroups" {
            if let groupsList = segue.destination as? GroupTableViewController{
                guard let id = self.userInformation[0].id else { return }
                groupsList.userId = id
            }
        }
    }
    
}


