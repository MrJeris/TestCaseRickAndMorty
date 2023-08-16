//
//  NetworkingManager.swift
//  TestCaseRickAndMorty
//
//  Created by Ruslan Magomedov on 17.08.2023.
//

import Foundation

final class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(_ endpoint: Endpoint, type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkingError.invalidUrl
        }
        
        let request = buildRequest(from: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode

            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode(T.self, from: data)
        
        return result
    }
    
    func request<T: Codable>(url urlString: String, type: T.Type) async throws -> T {
        
        guard let url = URL(string: urlString) else { throw NetworkingError.invalidUrl }
        
        let request = buildRequest(from: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode(T.self, from: data)
        
        return result
    }
}

extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidUrl
        case invalidData
        case invalidStatusCode(statusCode: Int)
        case failedToDecode(error: Error)
        case custom(error: Error)
    }
}

extension NetworkingManager.NetworkingError: Equatable {
    static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.invalidData, .invalidData):
            return true
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}

extension NetworkingManager.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Ошибка URL!"
        case .invalidStatusCode:
            return "Ошибка кода состояния!"
        case .invalidData:
            return "Данные ответа неверны!"
        case .failedToDecode:
            return "Ошибка декодирования данных!"
        case .custom(let error):
            return "Что-то пошло не так: \(error.localizedDescription)!"
        }
    }
}

private extension NetworkingManager {
    func buildRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}
