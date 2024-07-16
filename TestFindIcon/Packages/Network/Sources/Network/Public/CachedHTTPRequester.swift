//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import Foundation

public final class CachedHTTPRequester: HTTPRequestable {
    
    public init() {}
    
    public func sendRequest<T>(endPoint: any URLComponentsEndPoint, usingCache: Bool) async throws -> T where T : Decodable {
        let urlRequest = try RequestFactory.makeRequest(endPoint: endPoint,
                                                        usingCache: usingCache)
        
        let cacheName = endPoint.cacheId + ".txt"
        do {
            let data = try CacheService.getCachedData(for: cacheName)
            return try decode(data: data)
        } catch {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            try CacheService.deleteCache(for: cacheName)
            try CacheService.cacheData(data: data, for: cacheName)
            return try handleResponse(data: data, response: response)
        }
    }
    
     public func data(endPoint: any URLEndPoint, usingCache: Bool) async throws -> Data {
        let urlRequest = try RequestFactory.makeRequest(urlEndPoint: endPoint,
                                                        usingCache: usingCache)
         
         let cacheName = endPoint.cacheId + ".json"
        
        ///// try getting from cache or load from network
        do {
            let data = try CacheService.getCachedData(for: cacheName)
            return data
        } catch {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.response(.unknown(response: data))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.response(.connection(code: httpResponse.statusCode, response: data))
            }
            
            try CacheService.cacheData(data: data, for: cacheName)
            return data
        }
    }
}

