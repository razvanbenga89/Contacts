//
//  ContactsClient.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation

public struct Contact {
  public enum Gender: String {
    case male
    case female
  }
  
  public enum Status: String {
    case active
    case inactive
  }
  
  public let id: Int
  public let name: String
  public let email: String
  public var imagePath: String?
  public let gender: Gender
  public let status: Status
  
  public init(
    id: Int,
    name: String,
    email: String,
    imagePath: String? = "https://picsum.photos/200/200",
    gender: Gender,
    status: Status
  ) {
    self.id = id
    self.name = name
    self.email = email
    self.imagePath = imagePath
    self.gender = gender
    self.status = status
  }
}

extension Contact {
  public static var mocks: [Contact] {
    [
      Contact(id: 1, name: "Alina Manolache", email: "alina.manolache@mailinator.com", gender: .female, status: .active),
      Contact(id: 2, name: "Amalia Tudose", email: "amalia.tudose@mailinator.com", gender: .female, status: .active),
      Contact(id: 3, name: "Cezar Ionescu", email: "cezar.ionescu@mailinator.com", gender: .male, status: .active),
      Contact(id: 4, name: "Ioana Moldovan", email: "ioana.moldovan@mailinator.com", gender: .female, status: .active),
      Contact(id: 5, name: "Greta Nunu", email: "greta.nunu@mailinator.com", gender: .female, status: .active),
      Contact(id: 6, name: "Mihaela Piscu", email: "mihaela.piscu@mailinator.com", gender: .female, status: .active)
    ]
  }
}

public struct ContactsClient {
  public var getContacts: () async throws -> [Contact]
  
  public init(getContacts: @escaping () async throws -> [Contact]) {
    self.getContacts = getContacts
  }
}

extension ContactsClient {
  public static var previewValue: Self {
    Self(
      getContacts: {
        Contact.mocks
      }
    )
  }
}
