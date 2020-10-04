//
//  DrinkTableViewCell.swift
//  CocktailsLover
//
//  Created by Artem Musel on 15.09.2020.
//  Copyright © 2020 Artem Musel. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
  
  @IBOutlet weak var portraitImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var positionLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var imageUrl = ""
  
  func configure(_ user: User) {
    nameLabel.text = "\(user.firstName) \(user.lastName)"
    imageUrl = user.imageURL
    
    portraitImageView.image = nil
    portraitImageView.isHidden = true
    portraitImageView.layer.cornerRadius = portraitImageView.bounds.height/2
    portraitImageView.layer.borderWidth = 2
    portraitImageView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    activityIndicator.startAnimating()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      contentView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9882352941, alpha: 1)
    } else {
      contentView.backgroundColor = .white
    }
  }
}
