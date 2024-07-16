//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import Foundation

public protocol EndPoint: Cachable {}

public protocol URLComponentsEndPoint: EndPoint {
    var host: String { get throws }
    var scheme: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryParams: [String: String]? { get }
}

public protocol URLEndPoint: EndPoint {
    var url: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put =  "PUT"
    case delete = "DELETE"
}
