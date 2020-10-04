//
//  ViewController.swift
//  DummyAPI
//
//  Created by Artem Musel on 03.10.2020.
//

import UIKit
import SwiftUI

/*
  It is also possible to use prefetchDataSource to load images,
  but images are pretty lightweight and this will not
  notably improve speed
*/
class UsersTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  private let reuseIdentifier = "UserCell"
  
  @IBOutlet weak var loadButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private var users = [User]()
  private var currentPage = 0
  private var hasNothingToLoad = false
  
  //MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    fetchData()
  }
  
  //MARK: Actions
  @IBAction func tryAgainPressed(_ sender: UIButton) {
    fetchData()
  }
  
  private func fetchData() {
    loadButton.isHidden = true
    activityIndicator.startAnimating()
    
    NetworkManager.shared.requestForUsers(onPage: currentPage) { [weak self] users in
      guard let users = users else {
        DispatchQueue.main.async {
          self?.activityIndicator.stopAnimating()
          self?.loadButton.isHidden = false
        }
        return
      }
      
      if users.count > 0 {
        self?.currentPage += 1
      } else {
        self?.hasNothingToLoad = true
      }
      
      DispatchQueue.main.async {
        self?.activityIndicator.stopAnimating()
        self?.insertNewData(users)
      }
    }
  }
  
  private func insertNewData(_ newData: [User]) {
    if newData.count > 0 {
      var newIndexPaths = [IndexPath]()
      for rowPosition in 0..<newData.count {
        let newIndexPath = IndexPath(row: users.count + rowPosition, section: 0)
        newIndexPaths.append(newIndexPath)
      }
      self.users += newData
      self.tableView.insertRows(at: newIndexPaths, with: .automatic)
    }
  }
  
  //MARK: TableView Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let userCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserTableViewCell else {
      return UITableViewCell()
    }
    
    let user = users[indexPath.row]
    userCell.configure(user)
    
    NetworkManager.shared.requestForUserImage(withUrl: user.imageURL) {[weak userCell] image, url in
      DispatchQueue.main.async {
        if userCell?.imageUrl == url {
          userCell?.activityIndicator.stopAnimating()
          userCell?.portraitImageView.isHidden = false
          userCell?.portraitImageView.image = image
        }
      }
    }
    
    return userCell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == users.count - 1 && !hasNothingToLoad {
      fetchData()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = UIHostingController(rootView: UserSwiftUIView(user: users[indexPath.row]))
    navigationController?.pushViewController(vc, animated: true)
  }
}

