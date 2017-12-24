//
//  VIMetadataVCProtocol.swift
//  Complaint
//
//  Created by Nea on 12/24/17.
//  Copyright © 2017 Vinova. All rights reserved.
//

protocol VIMetadataProtocol {
    var id              : Int?      { get }
    var previewPath     : String?   { get }
    var originalPath    : String?   { get }
    
    // Currently support only: image/png | video/mp4
    var mimeType        : String?   { get }
}

protocol VIMetadataVCProtocol {
    static func instantiateFromNib(with dataList: [VIMetadataProtocol], playButtonImage: UIImage?) -> VIMetadataVC?
}
