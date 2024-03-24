//
//  ContactsClient.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation

struct Contact {
  enum Gender: String {
    case male
    case female
  }
  
  enum Status {
    case active
    case inactive
  }
  
  let id: Int
  let name: String
  let email: String
  var imagePath: String? = "https://picsum.photos/200/200"
  let gender: Gender
  let status: Status
}

extension Contact {
  static var mocks: [Contact] {
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

struct ContactsClient {
  var getContacts: () async throws -> [Contact]
}

extension ContactsClient {
  static var preview: Self {
    Self(
      getContacts: {
        Contact.mocks
      }
    )
  }
}
