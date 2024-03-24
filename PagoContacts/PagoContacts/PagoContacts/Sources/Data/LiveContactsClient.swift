//
//  LiveContactsClient.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation
import Domain

struct ContactDto: Decodable {
  enum Gender: String, Decodable {
    case male
    case female
  }
  
  enum Status: String, Decodable {
    case active
    case inactive
  }
  
  let id: Int
  let name: String
  let email: String
  let gender: Gender
  let status: Status
}

extension Contact {
  init(dto: ContactDto) {
    self.init(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      gender: Gender(rawValue: dto.gender.rawValue) ?? .male,
      status: Status(rawValue: dto.status.rawValue) ?? .inactive
    )
  }
  
  init?(entity: ContactEntity) {
    guard let name = entity.name,
          let email = entity.email,
          let gender = entity.gender,
          let status = entity.status else {
      return nil
    }
    
    self.init(
      id: Int(entity.contactId),
      name: name,
      email: email,
      gender: Gender(rawValue: gender) ?? .male,
      status: Status(rawValue: status) ?? .inactive
    )
  }
}

extension ContactsClient {
  public static var liveValue: Self {
    live(
      networkService: LiveNetworkService.shared,
      dbService: .liveValue
    )
  }
  
  public static func live(
    networkService: NetworkService,
    dbService: ContactsDBService
  ) -> Self {
    Self(
      getContacts: {
        let cachedContacts = try await dbService.getContacts()
        
        guard cachedContacts.isEmpty else {
          return cachedContacts.compactMap {
            Contact(entity: $0)
          }
        }
        
        let config = RequestConfig(
          path: { "public/v2/users" }
        )
        
        let contactsDto = try await networkService.request(dataType: [ContactDto].self, configuration: config)
        try await dbService.addContacts(contactsDto)
        
        return contactsDto.map {
          Contact(dto: $0)
        }
      }
    )
  }
}
