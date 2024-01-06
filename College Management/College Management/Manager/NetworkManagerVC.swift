//
//  NetworkManagerVC.swift
//  College Management
//
//  Created by ADMIN on 05/01/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    enum APIError: Error {
        case invalidURL
        case requestFailed
        case invalidResponse
        case dataParsingError
        case unauthorized
        // Add more error cases as needed
    }
    
    func request<T: Decodable>(
        method: HTTPMethod,
        endpoint: String,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard var urlComponents = URLComponents(string: "http://localhost:8080") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        urlComponents.path = endpoint
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            if method == .get {
                var queryItems = [URLQueryItem]()
                for (key, value) in parameters {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
                urlComponents.queryItems = queryItems
                request.url = urlComponents.url
            } else {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    completion(.failure(APIError.dataParsingError))
                    return
                }
            }
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0 // Set your desired timeout
        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            print("HTTP Response Code: \(httpResponse.statusCode)")
            print("HTTP Response Headers: \(httpResponse.allHeaderFields)")
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data!)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(APIError.dataParsingError))
                }
            } else if httpResponse.statusCode == 401 {
                completion(.failure(APIError.unauthorized))
            } else {
                completion(.failure(APIError.requestFailed))
            }
        }
        
        task.resume()
    }
}
