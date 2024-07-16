//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 26.06.24.
//

import Foundation
import RootFeature
import UIKit


// MARK: - Sign In

extension FindIconViewController {
    
    enum Views: String, Accessibility {
        
        typealias T = FindIconViewController
        
        case searchBar
        case collectionViewController
        
        var identifier: String  {
            
            get {
                return rawValue + String(describing: T.self)
            }
        }
    }
    
    func setAccessibilities() {
        self.searchController.searchBar.searchTextField.accessibilityIdentifier =  Views.searchBar.identifier
    }
}

