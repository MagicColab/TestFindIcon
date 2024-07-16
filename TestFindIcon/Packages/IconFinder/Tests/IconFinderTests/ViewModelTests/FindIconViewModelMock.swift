//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 25.06.24.
//

import Foundation
@testable import IconFinder
@testable import DataServices

struct FindIconServiceMock: FindIconService {
    
    let response: IconsResponse
    
    init(response: IconsResponse) {
        self.response = response
    }
    
    func getIcons(query: String, count: Int) async throws -> DataServices.IconsResponse {
        
        let task = Task<IconsResponse, Never> {
            
            return response
        }
        
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        return await task.value
    }
    
    func getIconImageData(url: String) async throws -> Data {
        let task = Task<Data, Never> {
            
            return Data()
        }
        
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        return await task.value
    }
}

struct FindIconRouterMock: FindIconRouting {
    func showDetails(for item: IconFinder.Item) {
        print("show delails")
    }
}
