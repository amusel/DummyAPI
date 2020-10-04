//
//  User.swift
//  DummyAPI
//
//  Created by Artem Musel on 03.10.2020.
//

import Foundation

class User: Decodable {
  let id: String
  let firstName: String
  let lastName: String
  let imageURL: String
  
  let location: Location?
  
  enum CodingKeys: String, CodingKey {
    case id, firstName, lastName, location
    case imageURL = "picture"
  }
  
  init() {
    id = ""
    firstName = "John"
    lastName = "Doe"
    imageURL = "https://randomuser.me/api/portraits/women/13.jpg"
    location = Location(country: "Ukraine", state: "", city: "", street: "")
  }
}

//helper for parsing
struct Users : Decodable {
  let data: [User]
}

struct Location: Decodable {
  let country: String
  let state: String
  let city: String
  let street: String
}
