//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 22.06.24.
//

import UIKit

public final class IconsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    public var sections = [Section]() {
        didSet {
            applySnapshot()
        }
    }
    public var updateItem: ((Item, Int) -> ())?
    
    private lazy var dataSource = makeDataSource()
    private let layout = UICollectionViewFlowLayout()
    
    public init() {
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        view.backgroundColor = .white
        self.registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Register Cell
    private func registerCell() {
        collectionView.register(IconCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: IconCollectionViewCell.self))
    }
    
    // MARK: - Creates DataSourse and cells when needed
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: IconCollectionViewCell.self),
                    for: indexPath) as? IconCollectionViewCell
                cell?.setItem(item: item)
                cell?.updateItem = { item in
                    self.updateItem?(item, indexPath.section)
                }
                return cell
            })
        return dataSource
    }
    
    // MARK: - Updates CollectionView - this method is called on sections changes
    func applySnapshot(animatingDifferences: Bool = true) {
      var snapshot = Snapshot()
      snapshot.appendSections(sections)
      sections.forEach { section in
        snapshot.appendItems(section.items, toSection: section)
      }
      dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      coordinator.animate(alongsideTransition: { context in
        self.collectionView.collectionViewLayout.invalidateLayout()
      }, completion: nil)
    }
    
//    //MARK: -- FlowLayout determines itemSize for collectionView
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 0.0
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            height = layout.itemSize.height
        }
        let screenSize = UIScreen.main
        let width = screenSize.bounds.size.width
        return CGSize(width: width, height: height)
    }
}
