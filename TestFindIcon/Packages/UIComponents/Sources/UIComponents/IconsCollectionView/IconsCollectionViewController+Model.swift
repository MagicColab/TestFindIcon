//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 22.06.24.
//

import UIKit

public extension IconsCollectionViewController {
     struct Section: Hashable {
      public var id = UUID()
      public var items: [Item]
      
      public init(items: [Item]) {
        self.items = items
      }
        public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
      }
      
        public static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
      }
    }
    
     struct Item: Hashable {
        public var id = UUID()
        public let iconId: Int
        public let tags: String
        public let imageURL: String
        public var imageData: Data = Data()
        public var isFavorite: Bool = false
        
        public static let defaulItem: Item = Item(iconId: 0,
                                                  tags: "",
                                                  imageURL: "default_url")
        
        public init(iconId: Int, tags: String, imageURL: String, imageData: Data = Data()) {
            self.iconId = iconId
            self.tags = tags
            self.imageURL = imageURL
            self.imageData = imageData
        }
        
        public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
      }
        
        public static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
      }
    }
}
