import XCTest
@testable import Data
@testable import Domain

final class LiveContactsClientTests: XCTestCase {
  func test_GetContacts_SavesToLocalDataSource() async throws {
    // Given
    let dbService = ContactsDBService.testValue
    let client = ContactsClient
      .build(
        networkService: MockNetworkService(),
        dbService: dbService
      )
    
    // When
    _ = try await client.getContacts()
    
    // Then
    let savedEntities = try await dbService.getContacts()
    XCTAssertTrue(savedEntities.contains(where: { $0.contactId == 6801599 }))
    XCTAssertTrue(savedEntities.contains(where: { $0.contactId == 6801598 }))
    XCTAssertTrue(savedEntities.contains(where: { $0.contactId == 6801597 }))
  }
  
  func test_GetContacts_GoesToRemoteDataSource_IfLocalDataIsMissing() async throws {
    // Given
    let dbService = ContactsDBService.testValue
    let savedEntities = try await dbService.getContacts()
    XCTAssertTrue(savedEntities.isEmpty)
    
    let networkService = MockNetworkService()
    XCTAssertFalse(networkService.didTriggerRequest)
    
    let client = ContactsClient
      .build(
        networkService: networkService,
        dbService: dbService
      )

    // When
    _ = try await client.getContacts()
    
    // Then
    XCTAssertTrue(networkService.didTriggerRequest)
  }
  
  func test_GetContacts_ReturnsJustLocalData_IfExists() async throws {
    // Given
    let dbService = ContactsDBService.testValue
    try await dbService.addContacts(
      [
        ContactDto(id: 1, name: "Test1", email: "test1@mailinator.com", gender: .male, status: .active),
        ContactDto(id: 2, name: "Test2", email: "test2@mailinator.com", gender: .female, status: .active),
      ]
    )
    let savedEntities = try await dbService.getContacts()
    XCTAssertFalse(savedEntities.isEmpty)
    
    let networkService = MockNetworkService()
    XCTAssertFalse(networkService.didTriggerRequest)
    
    let client = ContactsClient
      .build(
        networkService: networkService,
        dbService: dbService
      )
    
    // When
    let contacts = try await client.getContacts()
    
    // Then
    XCTAssertFalse(networkService.didTriggerRequest)
    
    XCTAssertTrue(contacts.contains(where: { $0.id == 1 }))
    XCTAssertTrue(contacts.contains(where: { $0.id == 2 }))
  }
}

extension LiveContactsClientTests {
  class MockNetworkService: NetworkService {
    var didTriggerRequest: Bool = false
    private let mockedResponse: String
    
    init(_ mockedResponse: String = .mockedResponse) {
      self.mockedResponse = mockedResponse
    }
    
    func request<T: Decodable>(dataType: T.Type, configuration: RequestConfig) async throws -> T {
      defer {
        didTriggerRequest = true
      }
      
      let data = Data(mockedResponse.utf8)
      return try JSONDecoder().decode(T.self, from: data)
    }
  }
}

extension String {
  static var mockedResponse =
    """
      [
        {
          "id": 6801599,
          "name": "Kannan Kaniyar V",
          "email": "v_kaniyar_kannan@douglas.test",
          "gender": "female",
          "status": "active"
        },
        {
          "id": 6801598,
          "name": "Ajit Tandon",
          "email": "tandon_ajit@greenholt.test",
          "gender": "male",
          "status": "inactive"
        },
        {
          "id": 6801597,
          "name": "Dandapaani Nair",
          "email": "nair_dandapaani@borer.test",
          "gender": "male",
          "status": "active"
        }
      ]
    """
}
