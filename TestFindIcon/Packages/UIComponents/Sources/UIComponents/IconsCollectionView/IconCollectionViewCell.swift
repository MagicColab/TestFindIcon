//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 22.06.24.
//

import UIKit

public final class IconCollectionViewCell: UICollectionViewCell {
    
    typealias Item = IconsCollectionViewController.Item
    
    var updateItem: ((Item) -> ())?
    
    private var item: Item = Item.defaulItem {
        didSet {
            updateSubView(item: item)
        }
    }
    
    private lazy var imageView = UIImageView()
    private lazy var tagsLabel = UILabel()
    private lazy var favoriteButton = UIButton.systemButton(with: UIImage(systemName: "heart") ?? UIImage(), target: self, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: .zero)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemGray6
        self.addSubviews()
    }
    
    private func addSubviews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftContentView = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightContentView = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topContentView = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomContentView = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topImageView = imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
        let widthImageView = imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(tagsLabel)
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        let topTagsLabel = tagsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        let withTagLabel = tagsLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 20)
        let centerXTagLabel = tagsLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        tagsLabel.numberOfLines = 0
        
        self.contentView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction(sender:)),
                                 for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        let topFavoritesButton = favoriteButton.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 10)
        let rightFavoriteButton = favoriteButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
        let bottomFavoriteButton = favoriteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        let widthFavButton = favoriteButton.widthAnchor.constraint(equalToConstant: 40)
        let heightFavButton = favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([leftContentView,
                                     rightContentView,
                                     topContentView,
                                     bottomContentView,
                                     topImageView,
                                     widthImageView,
                                     topTagsLabel,
                                     withTagLabel,
                                     centerXTagLabel,
                                     topFavoritesButton,
                                     rightFavoriteButton,
                                     bottomFavoriteButton,
                                     widthFavButton,
                                     heightFavButton])
        self.layoutIfNeeded()
    }
    
    func setItem(item: Item) {
        self.item = item
    }
    
    @MainActor
    private func updateSubView(item: Item) {
        tagsLabel.text = item.tags
        imageView.image = UIImage(data: item.imageData) ?? UIImage()
        setIsFavorite(item: item)
        layoutIfNeeded()
    }
    
    func setIsFavorite(item: Item) {
        favoriteButton.setImage(item.isFavorite == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
    
    @objc func favoriteButtonAction(sender: UIButton) {
        item.isFavorite = !item.isFavorite
        updateItem?(item)
    }
}
