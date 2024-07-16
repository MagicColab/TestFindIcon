//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import UIKit

protocol FindIconRouting {
    
    func showDetails(for item: Item)
}

final class FindIconRouter:FindIconRouting {
    
    weak var source: UIViewController?
    
    func showDetails(for item: Item) {
        /// implement
    }
}
