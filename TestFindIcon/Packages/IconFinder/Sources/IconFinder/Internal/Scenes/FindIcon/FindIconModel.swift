//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import Foundation
import RootFeature

struct FindIconModel {
    var searchText: String = ""
    var sections = Varable<[Section]>(value: [Section]())
    
    mutating func update(searchText: String, sections: [Section]) {
        self.searchText = searchText
        self.sections.value = sections
    }
}
