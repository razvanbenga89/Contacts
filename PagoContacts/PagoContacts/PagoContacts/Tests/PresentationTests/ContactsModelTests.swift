//
//  ContactsModelTests.swift
//
//
//  Created by Razvan Benga on 24.03.2024.
//

import XCTest
@testable import Presentation
@testable import Domain

extension Contact: Equatable {
  public static func == (lhs: Contact, rhs: Contact) -> Bool {
    lhs.id == rhs.id &&
    lhs.status.rawValue == rhs.status.rawValue
  }
}

final class ContactsModelTests: XCTestCase {
  func test_Load_FiltersOutInactiveContacts() async throws {
    // Given
    let activeContacts: [Contact] = [
      Contact(id: 1, name: "Alina Manolache", email: "alina.manolache@mailinator.com", gender: .female, status: .active),
      Contact(id: 3, name: "Cezar Ionescu", email: "cezar.ionescu@mailinator.com", gender: .male, status: .active),
      Contact(id: 5, name: "Greta Nunu", email: "greta.nunu@mailinator.com", gender: .female, status: .active)
    ]
    
    let client = ContactsClient {
      [
        Contact(id: 1, name: "Alina Manolache", email: "alina.manolache@mailinator.com", gender: .female, status: .active),
        Contact(id: 2, name: "Amalia Tudose", email: "amalia.tudose@mailinator.com", gender: .female, status: .inactive),
        Contact(id: 3, name: "Cezar Ionescu", email: "cezar.ionescu@mailinator.com", gender: .male, status: .active),
        Contact(id: 4, name: "Ioana Moldovan", email: "ioana.moldovan@mailinator.com", gender: .female, status: .inactive),
        Contact(id: 5, name: "Greta Nunu", email: "greta.nunu@mailinator.com", gender: .female, status: .active),
        Contact(id: 6, name: "Mihaela Piscu", email: "mihaela.piscu@mailinator.com", gender: .female, status: .inactive)
      ]
    }
    let model = ContactsModel(client: client)
    
    // When
    await model.load()
    
    // Then
    XCTAssertEqual(model.contacts, activeContacts)
  }
  
  func test_Load_SortsActiveContactsByName() async throws {
    // Given
    let sortedContactsNames: [String] = [
      "Alina Manolache",
      "Amalia Tudose",
      "Cezar Ionescu",
      "Greta Nunu",
      "Ioana Moldovan",
      "Mihaela Piscu"
    ]
    
    let client = ContactsClient {
      [
        Contact(id: 1, name: "Alina Manolache", email: "alina.manolache@mailinator.com", gender: .female, status: .active),
        Contact(id: 2, name: "Greta Nunu", email: "greta.nunu@mailinator.com", gender: .female, status: .active),
        Contact(id: 3, name: "Cezar Ionescu", email: "cezar.ionescu@mailinator.com", gender: .male, status: .active),
        Contact(id: 4, name: "Mihaela Piscu", email: "mihaela.piscu@mailinator.com", gender: .female, status: .active),
        Contact(id: 5, name: "Amalia Tudose", email: "amalia.tudose@mailinator.com", gender: .female, status: .active),
        Contact(id: 6, name: "Ioana Moldovan", email: "ioana.moldovan@mailinator.com", gender: .female, status: .active),
      ]
    }
    let model = ContactsModel(client: client)
    
    // When
    await model.load()
    
    // Then
    XCTAssertEqual(model.contacts.map { $0.name }, sortedContactsNames)
  }
}
