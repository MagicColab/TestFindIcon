//
//  File.swift
//  
//
//  Created by Zaruhi Davtyan on 20.06.24.
//

import Foundation


public struct IconsResponse: Decodable {
    public let totalCount: Int
    public let icons: [Icon]
    
    private enum CodingKeys: String, CodingKey {
           case totalCount = "total_count"
           case icons
    }
}

public struct Icons: Decodable {
    public let icons: [Icon]
}

public struct Icon: Decodable {
    public let iconId: Int
    public let tags: [String]
    public let sizes: [IconSize]
    
    private enum CodingKeys: String, CodingKey {
           case iconId = "icon_id"
           case tags
           case sizes = "raster_sizes"
    }
}

public struct IconSize: Decodable {
    public let formats: [IconFormat]
    public let size: Int
    
    public init(formats: [IconFormat], size: Int) {
        self.formats = formats
        self.size = size
    }
    
    private enum CodingKeys: String, CodingKey {
           case formats = "formats"
           case size
    }
}

public struct IconFormat: Decodable {
    public let format: String
    public let downloadUrl: String
    public let previewURL: String
    
    private enum CodingKeys: String, CodingKey {
           case format
           case downloadUrl = "download_url"
           case previewURL = "preview_url"
    }
}


