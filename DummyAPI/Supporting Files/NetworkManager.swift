//
//  NetworkManager.swift
//  DummyAPI
//
//  Created by Artem Musel on 03.10.2020.
//

import UIKit

class NetworkManager {
  
  static let shared = NetworkManager()
  private init() { }
  
  let imageCache = NSCache<NSString, UIImage>()
  var imageLoadingTasks = [String: URLSessionDataTask]()
  
  private let baseURL = "https://dummyapi.io/data/api"
  private let appIDHeader = "app-id"
  private let appID = "5f673807c6cba67fb8284491" //my appID 5f79fd81127ca22c0e1fd03c
  /*yesterday your appID stopped working due to limit.
   you can change appID to my if you face such a problem too */
  
  //MARK: Methods
  func requestForUsers(onPage page: Int = 0, completion: @escaping ([User]?)->Void) {
    guard let url = URL(string: "\(baseURL)/user?page=\(page)") else {
      return
    }
    
    var request = URLRequest(url: url)
    request.addValue(appID, forHTTPHeaderField: appIDHeader)
    
    let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard error == nil, let data = data else {
        completion(nil)
        return
      }
      
      let decoder = JSONDecoder()
      let users = (try? decoder.decode(Users.self, from: data))?.data

      completion(users)
    }

    dataTask.priority = URLSessionTask.highPriority
    dataTask.resume()
  }
  
  func requestForUser(withID id: String, completion: @escaping (User?)->Void) {
    guard let url = URL(string: "\(baseURL)/user/\(id)") else {
      return
    }
    
    var request = URLRequest(url: url)
    request.addValue(appID, forHTTPHeaderField: appIDHeader)
    
    let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard error == nil, let data = data else {
        completion(nil)
        return
      }
      
      let decoder = JSONDecoder()
      let user = try? decoder.decode(User.self, from: data)

      completion(user)
    }

    dataTask.priority = URLSessionTask.highPriority
    dataTask.resume()
  }
  
  func requestForUserImage(withUrl url: String, completion: @escaping (UIImage?, String)->Void) {
    if let cachedImage = imageCache.object(forKey: url as NSString) {
      completion(cachedImage, url)
    }

    imageLoadingTasks[url] = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
      guard let data = data, error == nil else { return }

      if let image = UIImage(data: data) {
        self.imageCache.setObject(image, forKey: url as NSString)
        completion(image, url)
      }

    }
    
    imageLoadingTasks[url]?.priority = URLSessionTask.lowPriority
    imageLoadingTasks[url]?.resume()
  }
}
