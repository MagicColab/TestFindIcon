//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 22.06.24.
//

import UIKit
import DataServices

protocol FindableIconViewModel {
    
    var model: FindIconModel { get set }
    func getFullIcons(for text: String) async throws
    func updateItem(with item: Item, at section: Int)
    func isSearchingValid(text: String?) -> Bool
    func isValidSearchText(text: String) -> Bool
}

final class FindIconViewModel: FindableIconViewModel {
    
    let dataService: FindIconService
    
    let router: FindIconRouting
    
    var model = FindIconModel()
    
    init(dataService: FindIconService, router: FindIconRouting) {
        self.dataService = dataService
        self.router = router
    }
    
    func getFullIcons(for text: String) async throws {
        try await withThrowingTaskGroup(of: (item: Item, imageData: Data).self) { group in
            let section = try await getIcons(text: text)
            for item in section.items {
                group.addTask {
                    try await (item, self.dataService.getIconImageData(url: item.imageURL))
                }
            }
            let items = try await group.reduce(into: [Item](repeating: Item.defaulItem,
                                                             count: section.items.count)) {
                let item = Item(iconId: $1.0.iconId,
                                tags: $1.0.tags,
                                imageURL: $1.0.imageURL,
                                imageData: $1.imageData)
                
                let id = $1.item.id
                
                //// keeping the order of array
                guard let rawItem = section.items.filter({ $0.id ==  id }).first else {
                    throw ParsingError.itemNotFound
                }
                guard let index = section.items.firstIndex(of: rawItem) else {
                    throw ParsingError.itemNotFound
                }
                $0[index] = item
                ////
            }
            let sectionWithImages = Section(items: items)
            self.model.update(searchText: text, sections: [sectionWithImages])
        }
    }
    
    private func getIcons(text: String) async throws -> Section {
            let iconsResponse =  try await dataService.getIcons(query: text, count: 10)
            let section = parseSection(iconReponse: iconsResponse)
            return section
    }
    
    private func parseSection(iconReponse: IconsResponse) -> Section {
        let items = iconReponse.icons.map { Item(iconId: $0.iconId,
                                                 tags: self.combineTags(tags: Array($0.tags.prefix(10))),
                                                 imageURL: self.imageURL(from: $0.sizes))}
        return Section(items: items)
    }
    
    private func combineTags(tags: [String]) -> String {
        return tags.reduce(" | ") { $0 +  $1 + " | " }
    }
    
    private func imageURL(from sizes: [IconSize]) -> String {
        let maxSize: IconSize = sizes.reduce(IconSize(formats: [], size: 0)) { $1.size > $0.size ? $1 : $0 }
        guard let pngFormat = maxSize.formats.filter({ $0.format == "png"}).first else {
            return "default_url"
        }
        return pngFormat.previewURL
    }
    
    func updateItem(with item: Item, at section: Int) {
        guard let index = model.sections.value.first?.items.firstIndex(of: item) else {
            return
        }
        model.sections.value[section].items[index] = item
    }
    
    func isSearchingValid(text: String?) -> Bool {
        /// text is nil
        guard let searchText = text else {
            emptifySections()
            return false
        }
        
        /// text is same as previous
        guard searchText != model.searchText else { return false }
        
        
        /// text is empty
        guard !searchText.isEmpty else {
           emptifySections()
                return false
        }
        
        /// need search
        return true
    }
    
    func isValidSearchText(text: String) -> Bool {
        text.count > 3
    }
    
    private func emptifySections() {
        let emptySections = [Section]()
        model.update(searchText: "", sections: emptySections)
    }
    
}

enum ParsingError: Error {
    case itemNotFound
}
