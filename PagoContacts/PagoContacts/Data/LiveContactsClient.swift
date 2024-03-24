//
//  LiveContactsClient.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation

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
}

extension ContactsClient {
  static var liveValue: Self {
    live(networkService: LiveNetworkService.shared)
  }
  
  static func live(
    networkService: NetworkService
  ) -> Self {
    Self(
      getContacts: {
        let config = RequestConfig(
          path: { "public/v2/users" }
        )
        
        let contactsDto = try await networkService.request(dataType: [ContactDto].self, configuration: config)
        let filteredContacts = contactsDto.filter { $0.status == .active }
        return filteredContacts.map {
          Contact(dto: $0)
        }
      }
    )
  }
}
