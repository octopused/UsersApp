//
//  UserInfoViewController.swift
//  UsersApp
//
//  Created by RuslanKa on 30.10.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    public var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    func setUI() {
        nameLabel.numberOfLines = 0
        dateOfBirthLabel.numberOfLines = 0
        phoneLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        emailLabel.numberOfLines = 0
        guard let user = user else { return }
        if let pictureUrl = user.pictureLargeUrl {
            do {
                let pictureData = try Data(contentsOf: pictureUrl)
                pictureView.image = UIImage(data: pictureData)
            } catch let error as NSError {
                print("Can't get the large picture. \(error.description)")
            }
        }
        dateOfBirthLabel.text = user.birthDateString
        locationLabel.text = user.location
        nameLabel.text = user.fullName!
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
}
