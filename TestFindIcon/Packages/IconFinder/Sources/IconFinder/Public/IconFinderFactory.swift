//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import UIKit
import Network
import DataServices

public final class IconFinderFactory {
    public static func makeIconFinderVC() -> UIViewController {
        let networkService = FindIconNetworkService(requester: CachedHTTPRequester())
        let router = FindIconRouter()
        let viewModel = FindIconViewModel(dataService: networkService, router: router)
        let vc = FindIconViewController(viewModel: viewModel)
        vc.updateItem = { item in
            IncomingIconUpdate.updateItem(item: item, for: .favoriteIcons)
        }
        router.source = vc
        let navController = UINavigationController(rootViewController: vc)
        return navController
    }
    
    public static func makeFavIconsVC() -> UIViewController {
        let viewModel = FavoriteIconsViewModel()
        let vc = FavoriteIconsViewController(viewModel: viewModel)
        vc.updateItem = { item in
            IncomingIconUpdate.updateItem(item: item, for: .findIcon)
        }
        return vc
    }
}
