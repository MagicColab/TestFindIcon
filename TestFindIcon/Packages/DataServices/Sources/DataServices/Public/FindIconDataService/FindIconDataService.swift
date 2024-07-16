//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import Foundation
import Network

public protocol FindIconService {
     func getIcons(query: String,
                  count: Int) async throws -> IconsResponse
    
     func getIconImageData(url: String) async throws -> Data
}

public final class FindIconNetworkService: FindIconService {
    
    private let requester: HTTPRequestable
    
    public init(requester: HTTPRequestable) {
        self.requester = requester
    }
    
    public func getIconImageData(url: String) async throws -> Data {
        let data = try await requester.data(endPoint: ImageDownloadEndPoint(url: url),
                                                usingCache: false)
        return data
    }
    
    public func getIcons(query: String,
                  count: Int) async throws -> IconsResponse {
           let endPoint = try SearchIconEndPoint(queryValue: query,
                                              count: count)
            async let response: IconsResponse = try await requester.sendRequest(endPoint: endPoint,
                                                                                usingCache: false)
            return try await response
        
        
    }
}
