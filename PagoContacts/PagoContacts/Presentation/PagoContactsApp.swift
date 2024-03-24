//
//  PagoContactsApp.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import SwiftUI

@main
struct PagoContactsApp: App {
  var body: some Scene {
    WindowGroup {
      ContactsView(
        model: ContactsModel(
          client: .liveValue
        )
      )
    }
  }
}
