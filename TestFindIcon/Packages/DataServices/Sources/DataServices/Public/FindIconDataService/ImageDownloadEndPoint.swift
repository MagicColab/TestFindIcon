//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 21.06.24.
//

import Foundation
import Network
import Configuration

struct ImageDownloadEndPoint: URLEndPoint, Cachable {
    
    var cacheId: String ////= Self.setDefaultCache()
    
    var url: String
    
    var method: Network.HTTPMethod = .get
    
    var header: [String : String]?
    
    var body: [String : String]? = nil
    
    init(url: String) throws {
        self.url = url
        try header = [
            "Authorization": "Bearer" + " " + Configuration.value(for: "API_KEY")
        ]
        self.cacheId = url.replacingOccurrences(of: "/", with: ".")
    }
}
