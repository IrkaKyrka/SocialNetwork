//
//  WallInformationTableViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/27/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit
import AVKit
import WebKit

enum Owner {
    case myself
    case somebody
}

var imageCache = [String: UIImage]()

class WallInformationTableViewController: UITableViewController {
    
    
    final var userId = 0
    final var token = ""
    private var posts = [WallItems]()
    private var profiles = [ProfilesInfo]()
    private var profilesOfGroup = [ProfileOfGroups]()
    private var nortification: UIAlertController!
    private let api = APIModel()
    private var playVideoId = ""
    
    
    let wallPostViewModelController = WallPostViewModelController()
    let wallOwnerViewModelController = WallOwnerViewModelController()
    let wallGroupViewModelController = WallGroupViewModelController()
    
    var wallParams = [
        "count": "7",
        "extended": "true"
    ]
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
     
        var center = self.view.center
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            center.y -= (navigationBarFrame.origin.y + navigationBarFrame.size.height)
        }
        activityIndicatorView.center = center
        
        self.view.addSubview(activityIndicatorView)
        return activityIndicatorView
    }()

    @IBAction func openAlert(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "", message: "Сообщение", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.api.postData(method: "wall.post", userId: Int(self.wallParams["user_id"]!)!, message: textField.text!, completion: { (error) in
                if error == nil{
                    DispatchQueue.main.async {
                        self.showNotification(message: "Запись добавлена")
                        self.getWallData()
                    }
                }
            })
        }))
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Введите текст:"
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wallParams["user_id"] = "\(api.userId)"
        getWallData()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.tableView.reloadData()

    }

 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wallPostViewModelController.viewModelsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as? WallInformationTableViewCell else { return UITableViewCell() }
        
        
        cell.historyPostImage.image = nil
        cell.historyOwnerDatePost.text = nil
        cell.historyOwnerImage.image = nil
        cell.historyPostText.text = nil
        cell.historyOwnerName.text = nil
        cell.historyPostImage.gestureRecognizers?.removeAll()
     

        
        let post = self.wallPostViewModelController.viewModel(at: indexPath.row)
        
        
        let ownerId = post?.ownerId
        let profile = self.wallOwnerViewModelController.wallOwnerViewModels.filter { $0!.ownerId == ownerId}[0]
        if let name = profile?.ownerName{
            cell.ownerName.text = name
        }
        if let imageOwner = profile!.ownerImage{
            if let cachedImage = imageCache[imageOwner]{
                cell.ownerImage.image = cachedImage
            }else{
                let image = getImage(imageString: imageOwner)
                imageCache[imageOwner] = image
                DispatchQueue.main.async {
                    cell.ownerImage.image = image
                }
            }
        }

        if let postText = post?.postText{
            cell.historyPostText.text = postText
        }
        
        let date = dateFormatting(dateJson: (post?.ownerDatePost)!)
        cell.ownerDatePost.text = date
        
        if let dataPost = post?.historyOwnerDatePost{
            let historyDatePost = dateFormatting(dateJson: dataPost)
            cell.historyOwnerDatePost.text = historyDatePost
        }
        
        if post?.attachmentType == "photo"{
            if let image = post?.postImage{
                if let cachedImage = imageCache[image]{
                     cell.historyPostImage.image = cachedImage
                } else {
                    let postImage = getImage(imageString: image)
                    imageCache[image] = postImage
                    DispatchQueue.main.async{
                        cell.historyPostImage.image = postImage
                    }
                }
            }
           
        } else {
            if let imageVideo = post?.postVideoImage{
                if let cachedImage = imageCache[imageVideo]{
                    cell.historyPostImage.image = cachedImage
                } else {
                    let postImage = getImage(imageString: imageVideo)
                    imageCache[imageVideo] = postImage
                    DispatchQueue.main.async{
                        cell.historyPostImage.image = postImage
                    }
                }
                addGesture(image: cell.historyPostImage, videoId: post?.videoId)
            }
        }

        if let historyId = post?.historyOwnerId{
            if historyId > 0{
                let profile = self.wallOwnerViewModelController.wallOwnerViewModels.filter { $0!.ownerId == historyId}[0]
                if let name = profile?.ownerName{
                    cell.historyOwnerName.text = name
                }
                if let imageOwner = profile!.ownerImage{
                    if let cachedImage = imageCache[imageOwner]{
                        cell.historyOwnerImage.image = cachedImage
                    } else{
                        let image = getImage(imageString: imageOwner)
                        imageCache[imageOwner] = image
                        DispatchQueue.main.async {
                            cell.historyOwnerImage.image = image
                        }
                    }
                }
            } else {
                let profile = self.wallGroupViewModelController.wallGroupViewModels.filter { $0!.groupId == abs(historyId)}[0]
                if let name = profile?.groupName{
                    cell.historyOwnerName.text = name
                }
                if let imageOwner = profile!.groupImage{
                    if let cachedImage = imageCache[imageOwner]{
                        cell.historyOwnerImage.image = cachedImage
                    } else{
                        let image = getImage(imageString: imageOwner)
                        imageCache[imageOwner] = image
                        DispatchQueue.main.async {
                            cell.historyOwnerImage.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }
 
    private func getWallData(){
        api.getData(method: "wall.get", params: wallParams) { (data) in
            do{
                
                let downloadedWall = try JSONDecoder().decode(Wall.self, from: data)
                self.wallPostViewModelController.initViewModels(downloadedWall.response.items)
                self.wallOwnerViewModelController.initViewModels(downloadedWall.response.profiles)
                self.wallGroupViewModelController.initViewModels(downloadedWall.response.groups)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    
                }
                
            }catch let error {
                
                print(error)
            }
        }
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
  
    private func showNotification(message: String){
        self.nortification = UIAlertController(title: "Уведомление", message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(self.nortification, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissNotification), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissNotification(){
        self.nortification.dismiss(animated: true, completion: nil)
    }

    private func addGesture(image: UIImageView, videoId: String?){
        self.playVideoId = videoId!
        image.isUserInteractionEnabled = true
        let tapGestreRecognizer = UITapGestureRecognizer(target: self, action: #selector(playVideoTap))
        image.addGestureRecognizer(tapGestreRecognizer)
        
    }

    @objc func playVideoTap(sender: UITapGestureRecognizer){
        
// реализация при помощи UIWebView
//        let myWebView:UIWebView = UIWebView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
//        
//        self.view.addSubview(myWebView)
//        
//        //1. Load web site into my web view
//        let url = URL(string: "https://vk.com/video_ext.php?oid=-550419&id=456239217&hash=2e1ee575ecb5c9fa&__ref=vk.api&api_hash=15473141592948075937d5f61a6d_GIYTEMJSGEZTQ")
//        let myURLRequest:URLRequest = URLRequest(url: url!)
//        myWebView.loadRequest(myURLRequest)

        let videoURL = "https://cs632300.vkuservideo.net/7/u214268/videos/115b80b6a6.720.mp4"
        let video = AVPlayer(url: URL(fileURLWithPath: videoURL))
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = video
        self.present(videoPlayer, animated: true,completion: {
            video.play()
        })

// реализация запроса видео по id. VK не дает доспут по API к ссылке на видео.
        /*api.getData(method: "video.get", params: [
            "videos": playVideoId
        ]) { (data) in
            do{
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
//                let downloadedVideo = try JSONDecoder().decode(Video.self, from: data)
//                let videoURL = downloadedVideo.response.items[0].files.mp4_720
                DispatchQueue.main.async {
                    let videoURL = "https://cs632300....Lg5KbOghSqfXXnWgZOQ"
                    let video = AVPlayer(url: URL(fileURLWithPath: videoURL))
                    let videoPlayer = AVPlayerViewController()
                    videoPlayer.player = video
                    self.present(videoPlayer, animated: true,completion: {
                        video.play()
                    })
                }
                
            }catch let error {
                
                print(error)
            }
        }*/
        
        
    }
    
    
}


