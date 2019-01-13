//
//  FriendsTableViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/30/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!

    private var friends = [FriendItems]()
    private var friendsOfFilter = [FriendItems]()
    
    var friendsParams = [
        "fields": "city,country,photo_100,online",
        "extended": "true"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setUpSearchBar()
        alterLayout()
        
        let api = APIModel()
        friendsParams["user_id"] = "\(api.userId)"
        api.getData(method: "friends.get", params: friendsParams) { (data) in
            do{
                
                let downloadedFriends = try JSONDecoder().decode(Friends.self, from: data)
                self.friends = downloadedFriends.response.items
                self.friendsOfFilter = self.friends
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error {
                print(error)
            }
        }
    
    }
    
    
    
    private func setUpSearchBar(){
        searchBar.delegate = self
        
    }
    
    private func alterLayout(){
        tableView.tableHeaderView = UIView()
        tableView.estimatedSectionHeaderHeight = 50
        navigationItem.titleView = searchBar
        searchBar.showsScopeBar = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsOfFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? FriendsTableViewCell else { return UITableViewCell()}
        
        cell.friendName.text = "\(friendsOfFilter[indexPath.row].first_name!) \(friendsOfFilter[indexPath.row].last_name!)"
        cell.friendStatus.text = (friendsOfFilter[indexPath.row].online != nil) ? "Online" : "Offline"

        if let imageUrl = URL(string: friendsOfFilter[indexPath.row].photo_100!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.friendImage.image = image
                        cell.friendImage.layer.cornerRadius = cell.friendImage.frame.size.width/2
                        cell.friendImage.clipsToBounds = true
                    }
                }
            }
        }
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            friendsOfFilter = friends
            tableView.reloadData()
            return
        }
        
        friendsOfFilter = friends.filter({ friend -> Bool in
            guard let name = friend.first_name else { return false }
            return (name.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }
}
