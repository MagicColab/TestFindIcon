//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import Foundation

public protocol HTTPRequestable {
     func  sendRequest<T: Decodable>(endPoint: URLComponentsEndPoint,
                                           usingCache: Bool) async throws -> T where T: Decodable
     func data(endPoint: any URLEndPoint,
                            usingCache: Bool) async throws -> Data
}

public struct HTTPRequester: HTTPRequestable {
    
    public init() {
        
    }

    public  func sendRequest<T>(endPoint: any URLComponentsEndPoint,
                                      usingCache: Bool = false) async throws -> T where T : Decodable {
        let urlRequest = try RequestFactory.makeRequest(endPoint: endPoint,
                                                        usingCache: usingCache)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        return try handleResponse(data: data, response: response)
    }
    
    public  func data(endPoint: any URLEndPoint,
                            usingCache: Bool = false) async throws -> Data {
        let urlRequest = try RequestFactory.makeRequest(urlEndPoint: endPoint,
                                                        usingCache: usingCache)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.response(.unknown(response: data))
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.response(.connection(code: httpResponse.statusCode, response: data))
        }
        return data
        
    }
}


/// helper function - parsing the response
extension HTTPRequestable {
      func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.response(.unknown(response: data))
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.response(.connection(code: httpResponse.statusCode, response: data))
        }
         
       return try decode(data: data)
       
    }
    
     func decode<T: Decodable>(data: Data) throws -> T {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.response(.decoding(error: error, response: data))
        }
    }
}
