//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 24.06.24.
//

import Foundation


public final class CacheService {
    static func getCachedData(for path: String) throws -> Data {
        let url = cachesDirectory.appendingPathComponent(path)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw CacheError.noCacheFound
        }
        
        let data = try Data(contentsOf: url)
        return data
    }
    
    static func cacheData(data: Data, for path: String) throws {
        let url = cachesDirectory.appendingPathComponent(path)
        try deleteCache(for: path)
        try data.write(to: url)
    }
    
    static func deleteCache(for path: String) throws {
        let url = cachesDirectory.appendingPathComponent(path)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }
    
    private static var cachesDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}

enum CacheError: Error {
    case noCacheFound
}

public protocol Cachable {
    var cacheId: String { get set }
}
