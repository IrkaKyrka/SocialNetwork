//
//  WallInformationTableViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/27/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit
import SwiftyJSON


class WallInformationTableViewController: UITableViewController {
    
    final var userId = 0
    final let token = ""
    private var posts = [WallItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInformationWall()
    }
    
    
    private func getInformationWall(){
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/wall.get"
        urlComponents.query = "user_id=\(userId)&count=1&extended=true&access_token=\(token)&v=5.92"
        
        
        guard let url = urlComponents.url else {return}
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do{
                
                let downloadedWall = try JSONDecoder().decode(Wall.self, from: data)
                self.posts = downloadedWall.response.items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //print("Groups count: \(downloadedGroups.response.items[0].name)")
                print("Массив Items = \(self.posts)")
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
        
        if let imageUrl = URL(string: (posts[indexPath.row].copy_history?[0].attachments?[0].photo?.sizes?[0].url)!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.historyPostImage.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
