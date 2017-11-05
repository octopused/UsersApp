//
//  APIManger.swift
//  UsersApp
//
//  Created by RuslanKa on 30.10.2017.
//  Copyright © 2017 RuslanKa. All rights reserved.
//

import Foundation

class APIManager {
    
    static func sendRequest(to urlString: String, completion: @escaping (Data?) -> Void) {
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    static func getUrlString() -> String {
        return "https://randomuser.me/api/"
    }
    
    static func getDateFormatString() -> String {
        return "yyyy-MM-dd HH:mm:ss"
    }
}
