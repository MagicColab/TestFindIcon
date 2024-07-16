//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 24.06.24.
//

import Foundation
import XCTest
@testable import IconFinder
@testable import DataServices


final class FindIconViewModelTests: XCTestCase {
    
    func testSectionsDataAfterNetworkRequest() async throws {
        let response = self.makeIconsResponse()
        let sut = FindIconViewModel(dataService: FindIconServiceMock(response: response),
                                    router: FindIconRouterMock())
        
        try await sut.getFullIcons(for: "text")
        
        let sections = sut.model.sections
        XCTAssertEqual(sections.value.count, 1)
        XCTAssertEqual(sections.value.first?.items.count, 2)
        
        let iconIds = response.icons.map{ $0.iconId }
        let recievedIds = sections.value.first?.items.map { $0.iconId }
        XCTAssertEqual(iconIds, recievedIds)
    }
    
    func testIsSearchingValid() {
        let sut = makeSUT()
        XCTAssertEqual(sut.isSearchingValid(text: nil), false)
        XCTAssertEqual(sut.isSearchingValid(text: "abc"), true)
        XCTAssertEqual(sut.isSearchingValid(text: ""), false)
        sut.model.searchText = "repeat"
        XCTAssertEqual(sut.isSearchingValid(text: sut.model.searchText), false)
    }
}

extension FindIconViewModelTests {
    
    func makeSUT() -> FindIconViewModel {
        let response = self.makeIconsResponse()
        let sut = FindIconViewModel(dataService: FindIconServiceMock(response: response),
                                    router: FindIconRouterMock())
        return sut
    }
    
    func makeIconsResponse() -> IconsResponse {
        let icons = [Icon(iconId: 1,
                          tags: ["test1"],
                          sizes: [IconSize(formats: [IconFormat(format: "png",
                                                                downloadUrl: "http://download.url",
                                                                previewURL: "http://download.url"),
                          ],
                                           size: 15)]),
                     Icon(iconId: 2,
                          tags: ["test2"],
                          sizes: [IconSize(formats: [IconFormat(format: "png",
                                                                downloadUrl: "http://download.url",
                                                                previewURL: "http://download.url"),
                          ],
                                           size: 15)])]
        let response = IconsResponse(totalCount: 3, icons: icons)
        return response
    }
}
