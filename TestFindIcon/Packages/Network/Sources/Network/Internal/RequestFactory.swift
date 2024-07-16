//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import Foundation

enum RequestFactory {
    static func makeRequest(endPoint: URLComponentsEndPoint,
                            usingCache: Bool = false) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host =  try endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryParams?.map({ (key, value) in
            URLQueryItem(name: key, value: value)
        })
        guard let url = urlComponents.url else {
            throw NetworkError.request(.invalidURL)
        }
        
        return try makeURLRequest(url: url,
                           usingCache: usingCache,
                           headers: endPoint.header,
                           httpMethod: endPoint.method,
                           body: endPoint.body)
    }
    
    static func makeRequest(urlEndPoint: URLEndPoint, usingCache: Bool) throws -> URLRequest {
        guard let url = URL(string: urlEndPoint.url) else {
            throw NetworkError.request(.invalidURL)
        }
        
        return try makeURLRequest(url: url,
                                  usingCache: usingCache,
                                  headers: urlEndPoint.header,
                                  httpMethod: urlEndPoint.method,
                                  body: urlEndPoint.body)
    }
}

/// helper function - creates URLRequest
private extension RequestFactory {
    private static func makeURLRequest(url: URL,
                             usingCache: Bool,
                             headers: [String: String]? = nil,
                             httpMethod: HTTPMethod,
                             body: [String: String]? = nil) throws -> URLRequest {
        let encoder = JSONEncoder()
        var request = URLRequest(url: url,
                                 cachePolicy: usingCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        return  request
    }
}


