//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 26.06.24.
//

import Foundation


public protocol Accessibility {
    associatedtype T
    var identifier: String { get }
    
}

public protocol Accessible {
    func setAccessibilities()
}

