//
//  GroupInformationViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/25/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

protocol GroupInformationViewControllerDelegate {
    func fillFavouriteGroup(name: String)
}

class GroupInformationViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var descriptionGroup: UILabel!
    
    private var nortification: UIAlertController!
    var delegate: GroupInformationViewControllerDelegate?
    private var groupDetail = [DetailsOfGroup]()
    
    var groupParams = [
        "fields": "city,country,place,members_count,description",
        "extended": "true"
    ]
    @IBAction func addFavouriteGroup(_ sender: UIBarButtonItem) {
        let groupName = name.text
        delegate?.fillFavouriteGroup(name: groupName!)
        self.showNotification(message: "Группа добавлена в избранные")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let api = APIModel()
        api.getData(method: "groups.getById", params: groupParams) { (data) in
            
            do{
                
                let downloadedDetailsOfGroup = try JSONDecoder().decode(GroupInformation.self, from: data)
                self.groupDetail = downloadedDetailsOfGroup.response
                
                DispatchQueue.main.async {
                    if let jsonCountry = self.groupDetail[0].country?.title,
                        let jsonCity = self.groupDetail[0].city?.title{
                        self.country.text = "\(jsonCountry), \(jsonCity)"
                    }
                    self.name.text = self.groupDetail[0].name
                    self.memberCount.text = "Участников \(String(self.groupDetail[0].members_count!))"
                    self.descriptionGroup.text = self.groupDetail[0].description
                    self.descriptionGroup.sizeToFit()
                }
                
                if let imageUrl = URL(string: self.groupDetail[0].photo_200!) {
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
            }catch let error {
                
                print(error)
            }
        }
    }
    
    private func showNotification(message: String){
        self.nortification = UIAlertController(title: "Уведомление", message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(self.nortification, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissNotification), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissNotification(){
        self.nortification.dismiss(animated: true, completion: nil)
    }
}
