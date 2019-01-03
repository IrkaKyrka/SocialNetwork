//
//  UserInformationViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/26/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit
import SwiftyVK


class UserInformationViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userBirthdayAndPlace: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var favouriteGroup: UILabel!
    
    var userParams = [
        "fields": "sex,bdate,city,country,place,photo_200,online",
        "extended": "true"
    ]
    
    var userInformation = [DetailsOfUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesture(image: userImage)
        
        let api: APIModel = APIModel()
        userParams["user_id"] = "\(api.userId)"
        api.getData(method: "users.get", params: userParams) { (data) in
            do{
                let downloadedInformationOfUser = try JSONDecoder().decode(UserInformation.self, from: data)
                self.userInformation = downloadedInformationOfUser.response
                
                DispatchQueue.main.async {
                    if let jsonFistName = self.userInformation[0].first_name,
                        let jsonLastName = self.userInformation[0].last_name{
                        self.userName.text = "\(jsonFistName) \(jsonLastName)"
                    }
                    //                    let date = Date()
                    //                    let formatter = DateFormatter()
                    //                    formatter.dateFormat = "dd.m.yyyy"
                    //                    let resultDate = formatter.String(from: date)
                    guard let jsonBirthday = self.userInformation[0].bdate else { return }
                    guard let jsonCountry = self.userInformation[0].country?.title else { return }
                    guard let jsonCity = self.userInformation[0].city?.title else { return }
                    self.userBirthdayAndPlace.text = "\(jsonBirthday) \(jsonCountry), \(jsonCity)"
                    self.userStatus.text = self.userInformation[0].online! == 0 ? "Offline" : "Online"
                }
                
                if let imageURL = URL(string: self.userInformation[0].photo_200!){
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: imageURL)
                        if let data = data {
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.userImage.image = image
                                self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
                               self.userImage.clipsToBounds = true
                            }
                        }
                    }
                }
                
            }catch let error {
                print(error)
            }
        }
       
    }
    
    func addGesture(image: UIImageView!){
        
        image.isUserInteractionEnabled = true
        let tapGestreRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        image.addGestureRecognizer(tapGestreRecognizer)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
     
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector (dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListOfGroups" {
            if let groupList = segue.destination as? GroupTableViewController {
                groupList.delegate = self
            }
        }
    }   
}

extension UserInformationViewController: GroupInformationViewControllerDelegate{
    func fillFavouriteGroup(name: String) {
        self.favouriteGroup.text = "Избранная группа: \(name)"
    }
    
    
}
