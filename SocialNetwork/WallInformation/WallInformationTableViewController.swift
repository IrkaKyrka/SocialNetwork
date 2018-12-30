//
//  WallInformationTableViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/27/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit
import AVKit

enum Owner {
    case myself
    case somebody
}


class WallInformationTableViewController: UITableViewController {
    
    final var userId = 0
    final var token = ""
    private var posts = [WallItems]()
    private var profiles = [ProfilesInfo]()
    private var profilesOfGroup = [ProfileOfGroups]()
    private var nortification: UIAlertController!

    @IBAction func openAlert(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "", message: "Сообщение", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.addPost(message: textField.text!)
        }))
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Введите текст:"
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
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
        
        var postOwner = Owner.myself
        if let copyHistory = self.posts[indexPath.row].copy_history {
            postOwner = Owner.somebody
        }
        
        let post = self.posts[indexPath.row]
        
        if let ownerId = post.owner_id{
            print("Owner \(ownerId)")
            let profile = profiles.filter { $0.id == ownerId}[0]
            if let name = profile.first_name, let lastName = profile.last_name{
                cell.ownerName.text = "\(name) \(lastName)"
            }
            if let imageOwner = profile.photo_100{
                let image = getImage(imageString: imageOwner)
                DispatchQueue.main.async {
                    cell.ownerImage.image = image
                }
            }
        }
        
        let date = dateFormatting(dateJson: post.date!)
        cell.ownerDatePost.text = date
        
        switch postOwner {
        case .myself:
            cell.historyOwnerName.isHidden = true
            cell.historyOwnerImage.isHidden = true
            cell.historyOwnerDatePost.isHidden = true
            cell.historyOwnerImage.image = UIImage()
            
            if let postText = post.text{
                cell.historyPostText.text = postText
            }
            if let attachments = post.attachments{
                if post.attachments?[0].type == "photo"{
                    let postOfImage = getImage(imageString: ((attachments[0].photo?.sizes?[2].url)!))
                    DispatchQueue.main.async{
                        cell.historyPostImage.image = postOfImage
                    }
                } else {
                    let postOfVideo = getImage(imageString: (attachments[0].video?.photo_320)!)
                    //let postOfVideo  = getVideo(videoString: (posts[indexPath.row].copy_history?[0].attachments?[0].video?.photo_320)!, size: )
                    DispatchQueue.main.async{
                        cell.historyPostImage.image = postOfVideo
                        
                    }
                    
                }
            } else {
                cell.historyPostImage.image = UIImage()
            }
        case .somebody:
            cell.historyOwnerName.isHidden = false
            cell.historyOwnerImage.isHidden = false
            cell.historyOwnerDatePost.isHidden = false

            let copyHistory = post.copy_history?[0]
            if let postText = copyHistory?.text{
                cell.historyPostText.text = postText
            }
            let historyDatePost = dateFormatting(dateJson: ((copyHistory?.date!)!))
            cell.historyOwnerDatePost.text = historyDatePost
            
            if let historyOwner = copyHistory?.owner_id{
                print("Owner \(historyOwner)")
                if historyOwner > 0 {
                    let profile = profiles.filter { $0.id == historyOwner}[0]
                    if let name = profile.first_name, let lastName = profile.last_name{
                        cell.historyOwnerName.text = "\(name) \(lastName)"
                    }
                    if let imageHistoryOwner = profile.photo_100{
                        let image = getImage(imageString: imageHistoryOwner)
                        DispatchQueue.main.async {
                            cell.historyOwnerImage.image = image
                        }
                    }
                } else {
                    let group = profilesOfGroup.filter { $0.id == abs(historyOwner)}[0]
                    if let name = group.name {
                        cell.historyOwnerName.text = name
                    }
                    if let imageHistoryOwner = group.photo_100{
                        let image = getImage(imageString: imageHistoryOwner)
                        DispatchQueue.main.async {
                            cell.historyOwnerImage.image = image
                        }
                    }
                }
                
                if let attachments = copyHistory?.attachments{
                    if copyHistory?.attachments?[0].type == "photo"{
                        let postOfImage = getImage(imageString: ((attachments[0].photo?.sizes?[2].url)!))
                        DispatchQueue.main.async{
                            cell.historyPostImage.image = postOfImage
                        }
                    } else {
                        
                        let postOfVideo = getImage(imageString: (attachments[0].video?.photo_320)!)
                        DispatchQueue.main.async{
                            cell.historyPostImage.image = postOfVideo
                        }
                        
                        
                    }
                } else {
                    cell.historyPostImage.image = UIImage()
                }
                
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
            let data = try? Data(contentsOf: imageUrl)
            if let data = data{
                image = UIImage(data: data)!
            }
        }
        return image
    }
    
    private func addPost(message: String){
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.post"
        urlComponents.query = "owner_id=\(userId)&message=\(message)&access_token=\(token)&v=5.92"
        
        
        guard let url = urlComponents.url else {return}
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            print(data)
            print(response)
            print(error)
            if error == nil{
                DispatchQueue.main.async {
                    self.showNotification(message: "Запись добавлена")
                    self.getInformationWall()
                }
            }
           
            }.resume()
    }
    
    private func showNotification(message: String){
        self.nortification = UIAlertController(title: "Уведомление", message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(self.nortification, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissNotification), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissNotification(){
        self.nortification.dismiss(animated: true, completion: nil)
    }
    
//    private func getVideo(videoString: String, size: CGRect) -> AVPlayer{
//        //        let player = AVPlayer(url: URL(string: videoString)!)
//        //        let playerLayer = AVPlayerLayer(player: player)
//        //        playerLayer.frame = self.view.bounds
//        //        self.view.layer.addSublayer(playerLayer)
//        let playerItem = AVPlayerItem(url: URL(string: videoString)!)
//        let player = AVPlayer(playerItem: playerItem)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = size
//        //      self.view.layer.addSublayer(playerLayer)
//        return player
//    }
    
//    private func addGesture(image: UIImageView?, video: String?){
//        if let image = image{
//        image.isUserInteractionEnabled = true
//        let tapGestreRecognizer = UITapGestureRecognizer(target: self, action: #selector(playVideoTap))
//        image.addGestureRecognizer(tapGestreRecognizer)
//        }
//    }
//
//    @objc func playVideoTap(sender: UITapGestureRecognizer){
//        let x = self.posts[0].copy_history?[0].attachments?[0].video?.photo_320
//            if let videoURL = self.posts[0].copy_history?[0].attachments?[0].video?.photo_320{
//                print(videoURL)
//                let video = AVPlayer(url: URL(fileURLWithPath: videoURL))
//                let videoPlayer = AVPlayerViewController()
//                videoPlayer.player = video
//                present(videoPlayer, animated: true,completion: {
//                    video.play()
//                })
//        }
//    }
    
}


