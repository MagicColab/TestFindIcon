//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import Foundation
import UIComponents
import RootFeature

typealias Section = IconsCollectionViewController.Section
typealias Item = IconsCollectionViewController.Item
typealias Subscription = IncomingIconUpdate.Subscription

protocol FavoriteableIconsViewModel {

    var sections: Varable<[Section]> { get set }
    
    func updateItem(item: Item, at section: Int) throws
}

final class FavoriteIconsViewModel: FavoriteableIconsViewModel {
    
    var sections: Varable<[Section]> = Varable(value: [Section(items: [Item]())])
    
    func updateItem(item: Item, at section: Int) throws {
        if item.isFavorite {
            sections.value[section].items.append(item)
        } else {
            guard let index = sections.value[section].items.firstIndex(where: { $0.id == item.id} ) else {
                throw FavoriteIconsError.iconNotFound
            }
            sections.value[section].items.remove(at: index)
        }
    }
}

enum FavoriteIconsError: Error {
    case iconNotFound
}
