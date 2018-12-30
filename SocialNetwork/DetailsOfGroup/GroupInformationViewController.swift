//
//  GroupInformationViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/25/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

class GroupInformationViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var descriptionGroup: UITextView!
    
    var groupId = 0
    final var token = ""
    
    var detailOfGroup = [DetailsOfGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInformationGroup()
        
    }
    
    
    
    private func getInformationGroup(){
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.getById"
        urlComponents.query = "group_ids=\(groupId)&fields=city,country,place,members_count,description&extended=true&access_token=\(token)&v=5.92"
        print("IDGroup = \(groupId)")
        
        guard let url = urlComponents.url else {return}
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do{
                
                let downloadedDetailsOfGroup = try JSONDecoder().decode(GroupInformation.self, from: data)
                self.detailOfGroup = downloadedDetailsOfGroup.response
                
                DispatchQueue.main.async {
                    if let jsonCountry = self.detailOfGroup[0].country?.title,
                        let jsonCity = self.detailOfGroup[0].city?.title{
                        self.country.text = "\(jsonCountry), \(jsonCity)"
                    }
                    self.name.text = self.detailOfGroup[0].name
                    self.memberCount.text = "Участников \(String(self.detailOfGroup[0].members_count!))"
                    self.descriptionGroup.text = self.detailOfGroup[0].description
                }
                
                if let imageUrl = URL(string: self.detailOfGroup[0].photo_200!) {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: imageUrl)
                        if let data = data{
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.image.image = image
                            }
                        }
                        
                    }
                    
                    
                }
                //print("Groups count: \(downloadedGroups.response.items[0].name)")
                print("Детали Группы = \(self.detailOfGroup)")
            }catch let error {
                print(error)
            }
            
            }.resume()
        
        
        
    }
}
