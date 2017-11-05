//
//  User.swift
//  UsersApp
//
//  Created by RuslanKa on 30.10.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import Foundation
import UIKit

class User {
    // Name
    var firstName: String
    var lastName: String
    var title: String?
    var gender: String?
    var fullName: String? {
        get {
            let firstName = capitalize(self.firstName)
            let lastName = capitalize(self.lastName)
            let title = capitalize(self.title)
            return "\(title) \(firstName) \(lastName)".trimmingCharacters(in: CharacterSet(charactersIn: " "))
        }
    }
    // Location
    var street: String?
    var city: String?
    var state: String?
    var postCode: String?
    var location: String? {
        get {
            let postCode = capitalize(self.postCode)
            let state = capitalize(self.state)
            let city = capitalize(self.city)
            let street = capitalize(self.street)
            return "\(postCode ?? "") \(state ?? "") \(city ?? "") \(street ?? "")"
        }
    }

    var email: String?
    var phone: String?
    var birthDate: Date?
    var birthDateString: String? {
        get {
            if let date = birthDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = APIManager.getDateFormatString()
                return dateFormatter.string(from: date)
            }
            return nil
        }
    }
    var pictureMediumUrl: URL?
    var pictureLargeUrl: URL?
    var pictureMedium: UIImage?
    var pictureLarge: UIImage?
    
    init(from userInfoDict: [String: String]) {
        self.firstName = userInfoDict["firstName"]!
        self.lastName = userInfoDict["lastName"]!
        self.title = userInfoDict["title"]
        self.gender = userInfoDict["gender"]
        self.postCode = userInfoDict["postCode"]
        self.state = userInfoDict["state"]
        self.city = userInfoDict["city"]
        self.street = userInfoDict["street"]
        self.phone = userInfoDict["phone"]
        self.email = userInfoDict["email"]
        let dateFormatter = DateFormatter()
        if let birthDateString = userInfoDict["birthDate"] {
            dateFormatter.dateFormat = APIManager.getDateFormatString()
            self.birthDate = dateFormatter.date(from: birthDateString)
        }
        if let pictureMediumUrlString = userInfoDict["pictureMediumUrlString"] {
            self.pictureMediumUrl = URL(string: pictureMediumUrlString)
            do {
                if let url = pictureMediumUrl {
                    let pictureData = try Data(contentsOf: url)
                    self.pictureMedium = UIImage(data: pictureData)
                }
            } catch let error as NSError {
                print("Could not get picture data. \(error.description)")
            }
        }
        if let pictureLargeUrlString = userInfoDict["pictureLargeUrlString"] {
            self.pictureLargeUrl = URL(string: pictureLargeUrlString)
        }
    }
    
    static func getUsers(usersData: Data) -> [User] {
        var users: [User] = []
        let usersInfo = getUserInfo(from: usersData)
        for userInfo in usersInfo {
            let user = User(from: userInfo)
            users.append(user)
        }
        return users
    }
    
    static private func getUserInfo(from jsonData: Data) -> [[String: String]] {
        var usersInfo: [[String: String]] = []
        var jsonDataSerialized: [String: Any]?
        do {
            jsonDataSerialized = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        } catch let error as NSError {
            print("Could not serialize user data. \(error.description)}")
        }
        guard jsonDataSerialized != nil else { return usersInfo }
        guard let jsonResults = jsonDataSerialized!["results"] as? [Any] else { return usersInfo }
        for jsonResult in jsonResults {
            guard let jsonUserInfo = jsonResult as? [String: Any] else { continue }
            guard let nameInfo = jsonUserInfo["name"] as? [String: String] else { continue }
            var userInfoDict: [String: String] = [:]
            userInfoDict["firstName"] = nameInfo["first"]
            userInfoDict["lastName"] = nameInfo["last"]
            userInfoDict["title"] = nameInfo["title"]
            if let locationInfo = jsonUserInfo["location"] as? [String: Any] {
                userInfoDict["postCode"] = locationInfo["postcode"] as? String
                userInfoDict["state"] = locationInfo["state"] as? String
                userInfoDict["city"] = locationInfo["city"] as? String
                userInfoDict["street"] = locationInfo["street"] as? String
            }
            userInfoDict["birthDate"] = jsonUserInfo["dob"] as? String
            userInfoDict["phone"] = jsonUserInfo["phone"] as? String
            userInfoDict["email"] = jsonUserInfo["email"] as? String
            userInfoDict["gender"] = jsonUserInfo["gender"] as? String
            if let pictureInfo = jsonUserInfo["picture"] as? [String: String] {
                userInfoDict["pictureMediumUrlString"] = pictureInfo["medium"]
                userInfoDict["pictureLargeUrlString"] = pictureInfo["large"]
            }
            usersInfo.append(userInfoDict)
        }
        return usersInfo
    }
    
    func capitalize(_ string: String?) -> String {
        if let string = string {
            let words = string.split(separator: " ")
            var sentence: String = ""
            for word in words {
                sentence.append(String(word.first!).capitalized + word.dropFirst())
                sentence.append(" ")
            }
            return sentence.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        }
        return ""
    }
}

