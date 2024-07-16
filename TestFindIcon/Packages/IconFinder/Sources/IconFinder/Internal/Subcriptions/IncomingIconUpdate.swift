//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import Foundation

protocol IncomingsUpdatable {
    func subscribeOnIncomings()
}

struct IncomingIconUpdate {
    
    struct Subscription {
        let completion: (Item) -> ()
        let key: Key
    }
    
    static var subscriptions = [Subscription]()
    static var updateIcon: ((Item) -> ())?
    
    static func addSubscription(subscription: Subscription) {
        subscriptions.append(subscription)
    }
    
    static func updateItem(item: Item, for key: Key) {
        
        guard let completion = subscriptions.filter({ $0.key == key }).first else {
            return
        }
        completion.completion(item)
    }
}

extension IncomingIconUpdate {
    enum Key: String {
        case findIcon
        case favoriteIcons
    }
}
