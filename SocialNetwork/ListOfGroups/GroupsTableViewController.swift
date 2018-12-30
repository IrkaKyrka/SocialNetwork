//
//  GroupTableViewController.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 12/20/18.
//  Copyright © 2018 Ira Golubovich. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    final var userId = 0
    final var token = ""
    private var groups = [Items]()
    private var groupsOfFilter = [Items]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
        setUpSearchBar()
        alterLayout()
        
    }
    
    private func getGroups(){
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.query = "user_id=\(userId)&count=100&extended=true&access_token=\(token)&v=5.92"
        
        
        guard let url = urlComponents.url else {return}
        print(url)
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do{
                
                let downloadedGroups = try JSONDecoder().decode(Groups.self, from: data)
                self.groups = downloadedGroups.response.items
                self.groupsOfFilter = self.groups
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //print("Groups count: \(downloadedGroups.response.items[0].name)")
                print("Массив Items = \(self.groups)")
            }catch let error {
                print(error)
            }
            
            }.resume()
        
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
        
        return groupsOfFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupTableViewCell else { return UITableViewCell()}
        
        cell.nameOfGroup.text = groupsOfFilter[indexPath.row].name
        
        //        cell.contentView.backgroundColor = UIColor.darkGray
        //        cell.backgroundColor = UIColor.lightGray
        
        if let imageUrl = URL(string: groupsOfFilter[indexPath.row].photo_200!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imageOfGroup.image = image
                    }
                }
            }
        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return searchBar
//    }
//
    
    //searchBar in section header
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            groupsOfFilter = groups
            tableView.reloadData()
            return
        }
        
        groupsOfFilter = groups.filter({ group -> Bool in
            guard let name = group.name else { return false }
            return (name.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }
}

extension GroupTableViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDitailsOfGroup" {
            if let groupInformation = segue.destination as? GroupInformationViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let cell = tableView.cellForRow(at: indexPath) as? GroupTableViewCell {
                        groupInformation.groupId = groups[indexPath.row].id!
                        groupInformation.token = token
                    }
                }
            }
        }
    }
}
