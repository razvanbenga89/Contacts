//
//  ContextProvider.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation
import CoreData

public enum DBError: Error {
  case dataModelNotFound
  case addEntityFailed
}

enum ContainerType {
  case inMemory
  case onDisk
}

class ContextProvider {
  var viewContext: NSManagedObjectContext {
    container.viewContext
  }
  
  static let sharedInstance = try! ContextProvider()
  private let container: NSPersistentContainer
  
  init(name: String = "DataModel", type: ContainerType = .onDisk) throws {
    guard let modelURL = Bundle.module.url(forResource: name, withExtension: "momd") else {
      throw DBError.dataModelNotFound
    }
    
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
      throw DBError.dataModelNotFound
    }
    
    container = NSPersistentContainer(name: name, managedObjectModel: model)
    
    if type == .inMemory {
      let description = NSPersistentStoreDescription()
      description.url = URL(fileURLWithPath: "/dev/null")
      container.persistentStoreDescriptions = [description]
    }
    
    container.loadPersistentStores { [weak self] _, error in
      guard error == nil else {
        return
      }
      self?.container.viewContext.automaticallyMergesChangesFromParent = true
    }
  }
}
