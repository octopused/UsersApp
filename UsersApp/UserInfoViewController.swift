//
//  UserInfoViewController.swift
//  UsersApp
//
//  Created by RuslanKa on 30.10.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

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

    @objc func createContact(_ gesture: UITapGestureRecognizer) {
        let contactStore = CNContactStore()
        let contact = CNMutableContact()
        contact.givenName = (user?.firstName)!
        contact.familyName = (user?.lastName)!
        if let phone = user?.phone {
            let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone))
            contact.phoneNumbers = [homePhone]
        }
        if let email = user?.email {
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: email as NSString)
            contact.emailAddresses = [homeEmail]
        }
        if let imageUrl = user?.pictureMediumUrl {
            do {
                contact.imageData = try Data(contentsOf: imageUrl)
            } catch {
                print("Could not get image data")
            }
        }
        let contactVC = CNContactViewController(forUnknownContact: contact)
        contactVC.contactStore = contactStore
        navigationController?.pushViewController(contactVC, animated: true)
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
        nameLabel.text = user.fullName
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        if let phoneString = user.phone {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createContact(_:)))
            phoneLabel.addGestureRecognizer(tapGestureRecognizer)
            phoneLabel.isUserInteractionEnabled = true
            let attributedText = NSMutableAttributedString(string: phoneString)
            attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, phoneString.count))
            phoneLabel.attributedText = attributedText
        }
        if let emailString = user.email {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createContact(_:)))
            emailLabel.addGestureRecognizer(tapGestureRecognizer)
            emailLabel.isUserInteractionEnabled = true
            let attributedText = NSMutableAttributedString(string: emailString)
            attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, emailString.count))
            emailLabel.attributedText = attributedText
        }
    }
}
