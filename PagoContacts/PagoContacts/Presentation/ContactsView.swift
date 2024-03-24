//
//  ContactsView.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import SwiftUI

extension Contact {
  var initials: String {
    name
      .components(separatedBy: " ")
      .prefix(2)
      .compactMap {
        guard let first = $0.first else {
          return nil
        }
        
        return String(first)
      }
      .joined()
  }
}

@Observable
class ContactsModel {
  let title: String = "Contacte"
  let sectionTitle: String = "Contactele mele"
  private (set) var contacts: [Contact] = []
  private let client: ContactsClient
  
  init(client: ContactsClient = .previewValue) {
    self.client = client
  }
  
  func load() async {
    do {
      self.contacts = try await client.getContacts()
    } catch {
      print(error)
      // handle error
    }
  }
}

struct ContactsView: View {
  let model: ContactsModel

  var body: some View {
    NavigationStack {
      List {
        Section(model.sectionTitle) {
          ForEach(
            Array(model.contacts.enumerated()),
            id: \.element.id
          ) { index, contact in
            NavigationLink {
              Text(contact.email)
            } label: {
              ContactView(
                model: ContactModel(
                  name: contact.name,
                  initials: contact.initials,
                  imagePath: index % 2 == 0 ? nil : contact.imagePath
                )
              )
            }
            .frame(minHeight: 80)
          }
        }
      }
      .navigationTitle(model.title)
      .listStyle(GroupedListStyle())
    }
    .task {
      await model.load()
    }
  }
}

struct ContactModel {
  let name: String
  let initials: String
  var imagePath: String?
}

struct ContactView: View {
  let model: ContactModel
  
  var body: some View {
    HStack(spacing: 20) {
      Group {
        if let imagePath = model.imagePath {
          AsyncImage(
            url: URL(string: imagePath),
            content: { image in
              image
                .resizable()
                .scaledToFit()
            },
            placeholder: {
              ProgressView()
            })
        } else {
          Text(model.initials)
            .foregroundStyle(.white)
        }
      }
      .frame(maxWidth: 60, maxHeight: 60)
      .background(.gray)
      .clipShape(Circle())
      
      Text(model.name)
    }
  }
}

#Preview {
  ContactsView(model: ContactsModel())
}
