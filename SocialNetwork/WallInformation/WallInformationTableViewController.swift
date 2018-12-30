//
//  WallInformationTableViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/27/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit
import AVKit



class WallInformationTableViewController: UITableViewController {
    
    final var userId = 0
    final var token = ""
    private var posts = [WallItems]()
    private var profiles = [ProfilesInfo]()
    private var profilesOfGroup = [ProfileOfGroups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInformationWall()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
    }
    
    
    private func getInformationWall(){
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.get"
        urlComponents.query = "user_id=\(userId)&count=7&extended=true&access_token=\(token)&v=5.92"
        
        
        guard let url = urlComponents.url else {return}
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do{
                
                let downloadedWall = try JSONDecoder().decode(Wall.self, from: data)
                self.posts = downloadedWall.response.items
                self.profiles = downloadedWall.response.profiles
                self.profilesOfGroup = downloadedWall.response.groups
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //print("Groups count: \(downloadedGroups.response.items[0].name)")
                print("Массив Items = \(self.posts)")
                print("Массив profiles = \(self.profiles)")
            }catch let error {
                print(error)
            }
            
            
            }.resume()
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as? WallInformationTableViewCell else { return UITableViewCell() }
        if let postText = self.posts[indexPath.row].copy_history?[0].text{
            cell.historyPostText.text = postText
        }
        
        if let owner = self.posts[indexPath.row].owner_id{
            print("Owner \(owner)")
            let filter = profiles.filter { $0.id == owner}
            if let name = filter[0].first_name, let lastName = filter[0].last_name{
                cell.ownerName.text = "\(name) \(lastName)"
            }
            if let imageOwner = filter[0].photo_100{
                let image = getImage(imageString: imageOwner)
                DispatchQueue.main.async {
                    cell.ownerImage.image = image
                }
            }
        }
        
        let date = dateFormatting(dateJson: self.posts[indexPath.row].date!)
        
        
        cell.ownerDatePost.text = date
        
        if let copyHistory = self.posts[indexPath.row].copy_history{
            let historyDatePost = dateFormatting(dateJson: (copyHistory[0].date!))
            
            cell.historyOwnerDatePost.text = historyDatePost
            
        }
        
        if let historyOwner = self.posts[indexPath.row].copy_history?[0].owner_id{
            print("Owner \(historyOwner)")
            if historyOwner > 0{
                let filter = profiles.filter { $0.id == historyOwner}
                if let name = filter[0].first_name, let lastName = filter[0].last_name{
                    cell.historyOwnerName.text = "\(name) \(lastName)"
                }
                if let imageHistoryOwner = URL(string: (filter[0].photo_100!)){
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: imageHistoryOwner)
                        if let data = data{
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                cell.historyOwnerImage.image = image
                            }
                        }
                    }
                }
            }else{
                let filterOfGroups = profilesOfGroup.filter { $0.id == abs(historyOwner)}
                if let name = filterOfGroups[0].name{
                    cell.historyOwnerName.text = name
                }
                let imageHistoryOwner = getImage(imageString: filterOfGroups[0].photo_100!)
                DispatchQueue.main.async {
                    cell.historyOwnerImage.image = imageHistoryOwner
                }
            }
            
            if let attachments = posts[indexPath.row].copy_history?[0].attachments{
                if posts[indexPath.row].copy_history?[0].attachments?[0].type == "photo"{
                    let postOfImage = getImage(imageString: ((posts[indexPath.row].copy_history?[0].attachments?[0].photo?.sizes?[2].url)!))
                    DispatchQueue.main.async{
                        cell.historyPostImage.image = postOfImage
                    }
                } else {
                    
                    let postOfVideo = getImage(imageString: (attachments[0].video?.photo_320)!)
                    //            let postOfVideo  = getVideo(videoString: (posts[indexPath.row].copy_history?[0].attachments?[0].video?.photo_320)!, size: )
                    DispatchQueue.main.async{
                        cell.historyPostImage.image = postOfVideo
                        
                    }
                    
                    
                }
            } else {
                cell.historyPostImage.image = UIImage()
            }
            
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
    }
    
    private func dateFormatting(dateJson: Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy hh:mm:ss"
        let datePost = Date(timeIntervalSince1970: TimeInterval(dateJson))
        let date = dateFormatter.string(from: datePost)
        
        return date
    }
    
    private func getImage(imageString: String) -> UIImage{
        var image = UIImage()
        if let imageUrl = URL(string: imageString){
            //           DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageUrl)
            if let data = data{
                image = UIImage(data: data)!
                
            }
            //            }
        }
        //        guard let image1 = image else { return UIImage()}
        return image
    }
    
    private func getVideo(videoString: String, size: CGRect) -> AVPlayer{
        //        let player = AVPlayer(url: URL(string: videoString)!)
        //        let playerLayer = AVPlayerLayer(player: player)
        //        playerLayer.frame = self.view.bounds
        //        self.view.layer.addSublayer(playerLayer)
        let playerItem = AVPlayerItem(url: URL(string: videoString)!)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = size
        //      self.view.layer.addSublayer(playerLayer)
        return player
    }
    
}


