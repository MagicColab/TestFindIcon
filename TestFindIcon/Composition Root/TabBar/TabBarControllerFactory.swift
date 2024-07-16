//
//  TabBarControllerFactory.swift
//  TestFindIcon
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import UIKit
import IconFinder

struct TabBarControllerFactory {
    
    static func make() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.tintColor = .systemPink
        tabBarController.viewControllers = makeViewControllers()
        return tabBarController
    }
    
    private static func makeViewControllers() -> [UIViewController] {
        [makeIconFinder(), makeFavIcons()]
    }
    
    private static func makeIconFinder() -> UIViewController {
        let iconFinderItem = UITabBarItem()
        iconFinderItem.title = "Icon Finder"
        iconFinderItem.image = UIImage(systemName: "doc.text.magnifyingglass")
        let iconFinderVC = IconFinderFactory.makeIconFinderVC()
        iconFinderVC.tabBarItem = iconFinderItem
        return iconFinderVC
    }
    
    private static func makeFavIcons() -> UIViewController {
        let favIconsItem = UITabBarItem()
        favIconsItem.title = "Favorite Icons"
        favIconsItem.image = UIImage(systemName: "heart.fill")
        let favIconsVC = IconFinderFactory.makeFavIconsVC()
        favIconsVC.tabBarItem = favIconsItem
        return favIconsVC
    }
    
    
}
