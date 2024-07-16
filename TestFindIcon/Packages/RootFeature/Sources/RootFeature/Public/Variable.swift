//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 07.06.24.
//

import Foundation


public struct Varable<T> {
    
    public typealias Listener = (T) -> ()
    
    private var listener: Listener?
    
    public var value: T {
        didSet {
            listener?(value)
        }
    }
    
    public init(value: T) {
        self.value = value
    }
    
    public mutating func bind(listener: @escaping Listener) {
        self.listener = listener
    }
    
    public mutating func bindAndFire(listener: @escaping Listener) {
        self.listener = listener
        self.listener?(value)
    }
}
