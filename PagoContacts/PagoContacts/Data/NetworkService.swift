//
//  NetworkService.swift
//  PagoContacts
//
//  Created by Razvan Benga on 24.03.2024.
//

import Foundation

#if DEBUG
let basePath = "https://gorest.co.in/"
#endif

enum APIError: LocalizedError {
  case invalidURL
}

enum HttpMethod: String {
  case get
  case post
  case put
  case delete
}

struct RequestConfig {
  let httpMethod: () -> HttpMethod
  let path: () -> String
  let headers: () -> [String: String]
  let parameters: () -> Encodable?
  
  init(
    httpMethod: @escaping () -> HttpMethod = { .get },
    path: @escaping () -> String,
    headers: @escaping () -> [String : String] = { [:] },
    parameters: @escaping () -> Encodable? = { nil }) {
      self.httpMethod = httpMethod
      self.path = path
      self.headers = headers
      self.parameters = parameters
    }
}

extension RequestConfig {
  var fullPath: String {
    basePath + path()
  }
}

protocol NetworkService {
  func request<T: Decodable>(dataType: T.Type, configuration: RequestConfig) async throws -> T
}

class LiveNetworkService: NetworkService {
  static var shared: NetworkService = LiveNetworkService()
  
  private init() {}
  
  func request<T: Decodable>(dataType: T.Type, configuration: RequestConfig) async throws -> T {
    guard let url = URL(string: configuration.fullPath) else {
      throw APIError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = configuration.httpMethod().rawValue
    urlRequest.allHTTPHeaderFields = configuration.headers()
    urlRequest.httpBody = try configuration.parameters().map { try JSONEncoder().encode($0) }
    
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    let dto = try JSONDecoder().decode(dataType, from: data)
    
    return dto
  }
}
