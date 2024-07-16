//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 23.06.24.
//

import UIKit
import UIComponents

final class FavoriteIconsViewController: UIViewController, IncomingsUpdatable {
    
    var viewModel: FavoriteableIconsViewModel
    
    var updateItem: ((Item) -> ())?
    
    private lazy var collectionViewController: IconsCollectionViewController = IconsCollectionViewController()
    
    init(viewModel: FavoriteableIconsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(viewModel: FavoriteIconsViewModel())
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewController()
    }
    
    private func configureCollectionViewController() { //// move to delegate - how to work with collectionvc
        self.addChild(collectionViewController)
        self.addCollectionViewController()
        collectionViewController.didMove(toParent: self)
    }
    
    private func addCollectionViewController() { //// move to delegate function, way how to work with collectionvc
        self.view.addSubview(collectionViewController.view)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottom = collectionViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let left = collectionViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let right = collectionViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        NSLayoutConstraint.activate([top, bottom, left, right])
    }
    
    private func bindViewModel() {
        viewModel.sections.bindAndFire(listener: { [weak self] sections in
            DispatchQueue.main.async {
                self?.collectionViewController.sections = sections
            }
        })
        
        collectionViewController.updateItem = { [weak self] item, section in
            self?.viewModelItemUpdate(item: item, section: section)
            self?.updateItem?(item)
        }
        
        subscribeOnIncomings()
    }
    
    private func viewModelItemUpdate(item: Item, section: Int) {
        do {
            try viewModel.updateItem(item: item, at: section)
        } catch {
            print(error)
        }
    }
    
    func subscribeOnIncomings() {
        let completion: (Item) -> () = {[weak self] item in
            self?.viewModelItemUpdate(item: item, section: 0)
        }
        let subscription = Subscription(completion: completion,
                                        key: .favoriteIcons)
        IncomingIconUpdate.addSubscription(subscription: subscription)
    }
    
}
