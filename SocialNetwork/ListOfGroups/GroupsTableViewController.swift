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
    
    private var groups = [Items]()
    private var groupsOfFilter = [Items]()
    
    var delegate: GroupInformationViewControllerDelegate?
    
    var groupsParam = [
        "user_ids": "21212138",
        "extended": "true"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSearchBar()
        alterLayout()
        
        let api = APIModel()
        groupsParam["user_ids"] = "\(api.userId)"
        api.getData(method: "groups.get", params: groupsParam) { (data) in
            do{
                
                let downloadedGroups = try JSONDecoder().decode(Groups.self, from: data)
                self.groups = downloadedGroups.response.items
                self.groupsOfFilter = self.groups
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
        return groupsOfFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupTableViewCell else { return UITableViewCell()}
        
        cell.groupName.text = groupsOfFilter[indexPath.row].name
        
        if let imageUrl = URL(string: groupsOfFilter[indexPath.row].photo_200!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data{
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.groupImage.image = image
                        cell.groupImage.layer.cornerRadius = cell.groupImage.frame.size.width/2
                        cell.groupImage.clipsToBounds = true
                    }
                }
            }
        }
        return cell
    }
    
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
                        groupInformation.groupParams["group_ids"] = "\(groups[indexPath.row].id!)"
                        groupInformation.delegate = self.delegate
                    }
                }
            } 
        }
    }
}
