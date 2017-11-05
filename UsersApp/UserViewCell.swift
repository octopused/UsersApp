//
//  UserViewCell.swift
//  UsersApp
//
//  Created by RuslanKa on 02.11.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user: User? {
        didSet {
            setUI()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUI() {
        guard let user = user else { return }
        nameLabel.text = user.fullName
        if let pictureMedium = user.pictureMedium {
            pictureView.image = pictureMedium
        } else {
            do {
                if let url = user.pictureMediumUrl {
                    let pictureData = try Data(contentsOf: url)
                    pictureView.image = UIImage(data: pictureData)
                    user.pictureMedium = pictureView.image
                }
            } catch let error as NSError {
                print("Could not get picture data. \(error.description)")
            }
        }
    }
}
