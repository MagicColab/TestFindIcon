//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import Foundation
import Network
import Configuration


struct SearchIconEndPoint: URLComponentsEndPoint, Cachable {
    
    var cacheId: String
    
    let queryValue: String
    
    let count: Int
    
    var host: String
    
    var scheme: String = "https"
    
    var path: String = "/v4/icons/search"
    
    var method: Network.HTTPMethod = .get
    
     var header: [String : String]?
    
    var body: [String : String]?
    
    var queryParams: [String : String]? ///= ["query": queryValue, "per_page": "40"]
    
    init(
        queryValue: String,
        count: Int
    ) throws {
        self.queryValue = queryValue
        self.count = count
        self.host = try Configuration.value(for: "BASE_URL")
        self.cacheId = String(describing: SearchIconEndPoint.self) + ".\(queryValue)"
        try setUpValues()
    }
    
    private mutating func setUpValues() throws {
        try header = [
            "Authorization": "Bearer" + " " + Configuration.value(for: "API_KEY"),
            "accept": "application/json"
        ]
        
        queryParams = [
            "query": queryValue,
            "count": String(count)
        ]
        
        
    }
}
