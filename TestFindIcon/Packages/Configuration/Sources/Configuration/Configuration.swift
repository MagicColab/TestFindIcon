// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation

public struct Configuration {
    enum Error: Swift.Error {
        case missingKey
        case invalidValue
        case emptyValue
    }
    
    public static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard !string.isEmpty else { throw Error.emptyValue }
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}
