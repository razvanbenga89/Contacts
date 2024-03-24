//
//  ContactsDBService.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation

public struct ContactsDBService {
  var addContacts: (_ contacts: [ContactDto]) async throws -> Void
  var getContacts: () async throws -> [ContactEntity]
}

extension ContactsDBService {
  static var testValue: ContactsDBService {
    build(containerType: .inMemory)
  }
  
  static var liveValue: ContactsDBService {
    build(containerType: .onDisk)
  }
  
  private static func build(
    containerType: ContainerType
  ) -> Self {
    let contextProvider = try! ContextProvider(type: containerType)
    
    return Self(
      addContacts: { dtos in
        let context = contextProvider.viewContext
        
        try await context.perform {
          dtos.forEach { dto in
            let entity = ContactEntity(context: context)
            entity.contactId = Int64(dto.id)
            entity.name = dto.name
            entity.email = dto.email
            entity.gender = dto.gender.rawValue
            entity.status = dto.status.rawValue
          }
          
          do {
            try context.save()
          } catch {
            throw DBError.addEntityFailed
          }
        }
      },
      getContacts: {
        let context = contextProvider.viewContext
        let fetchRequest = ContactEntity.fetchRequest()
        return try context.fetch(fetchRequest)
      }
    )
  }
}
