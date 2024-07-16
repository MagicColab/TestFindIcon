//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import UIKit
import Combine
import Network
import UIComponents
import DataServices
import RootFeature

final class FindIconViewController: UIViewController, UISearchResultsUpdating, IncomingsUpdatable, Accessible {
    
    var viewModel: FindableIconViewModel
    
    var updateItem: ((Item) -> ())?
    
    private var subscriptions = Set<AnyCancellable>()
    private let searchTextSubject: CurrentValueSubject<String, Never> = .init("")
    
    init(viewModel: FindableIconViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(viewModel: FindIconViewModel(dataService: FindIconNetworkService(requester: CachedHTTPRequester()),
                                               router: FindIconRouter()))
    }
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var collectionViewController = IconsCollectionViewController()
    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSearchController()
        setupSearchPublisher()
        configureCollectionViewController()
        configureActivityIndicator()
        setAccessibilities()
    }
    
    private func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search Icons"
      navigationItem.searchController = searchController
      definesPresentationContext = true
    }
    
    private func configureCollectionViewController() {
        self.addChild(collectionViewController)
        self.addCollectionViewController()
        collectionViewController.didMove(toParent: self)
    }
    
    private func addCollectionViewController() {
        self.view.addSubview(collectionViewController.view)
        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        let bottom = collectionViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let left = collectionViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        let right = collectionViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        NSLayoutConstraint.activate([top, bottom, left, right])
    }
    
    private func configureActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func bindViewModel() {
        viewModel.model.sections.bindAndFire(listener: {[weak self] sections in
            DispatchQueue.main.async {
                self?.collectionViewController.sections = sections
                self?.activityIndicator.stopAnimating()
            }
        })
        
        collectionViewController.updateItem = {[weak self] item, section in
            self?.viewModel.updateItem(with: item, at: section)
            self?.updateItem?(item)
        }
        
        subscribeOnIncomings()
    }
    
    func subscribeOnIncomings() {
        
        let completion: (Item) -> () = {[weak self] item in
             self?.viewModel.updateItem(with: item, at: 0)
        }
        let subscription = Subscription(completion: completion,
                                        key: .findIcon)
        IncomingIconUpdate.addSubscription(subscription: subscription)
    }
    
    private func setupSearchPublisher() {
        searchTextSubject
            .compactMap({ $0 })
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard text.count > 3 else { return }
                self?.getFullIcons(text: text)
            }
            .store(in: &subscriptions)
    }
    
    private func getFullIcons(text: String) {
        activityIndicator.startAnimating()
        Task {
            do {
                try await viewModel.getFullIcons(for: text)
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                }
                print(error)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard viewModel.isSearchingValid(text: searchController.searchBar.text) else { return }
        
        searchTextSubject.send(searchController.searchBar.text ?? "")
    }
}
