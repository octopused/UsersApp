//
//  UsersTableViewController.swift
//  UsersApp
//
//  Created by RuslanKa on 03.11.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

    @IBAction func addUserBarButtonTouched(_ sender: UIBarButtonItem) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            self.addUsers(count: 10)
        }
    }
    var users: [User] = []
    var selectedUser: User?
    var addingUsers = false {
        didSet {
            if addingUsers {
                navigationItem.title = "Adding users..."
            } else {
                navigationItem.title = "Users"
            }
        }
    }
    
    let cellIdentifier = "userCell"
    let toUserInfoSegueName = "toUserInfo"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addUsers(count: 10)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let userCell = cell as? UserViewCell {
            userCell.user = users[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
        performSegue(withIdentifier: toUserInfoSegueName, sender: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        if distanceFromBottom < height {
            if !addingUsers {
                addUsers(count: 10)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toUserInfoSegueName {
            if let userInfoVC = segue.destination as? UserInfoViewController {
                userInfoVC.user = selectedUser
            }
        }
    }
 
    // MARK: - Other
    
    func addUsers(count: Int) {
        addingUsers = true
        let url = URL(string: "https://randomuser.me/api/?results=\(count)")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                print("Could not get data of \(url.description)")
                return
            }
            let newUsers = User.getUsers(usersData: data!)
            self?.users.append(contentsOf: newUsers)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.addingUsers = false
            }
        }
        task.resume()
    }
}
