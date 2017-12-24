//
//  VIMetadataCell.swift
//  Hooha-M
//
//  Created by Nea on 12/12/17.
//  Copyright © 2017 Vinova. All rights reserved.
//

import SDWebImage

class VIMetadataCell: UICollectionViewCell {
    
    @IBOutlet weak var imvMain: UIImageView!
    @IBOutlet weak var imvPlay: UIImageView!
    
    static var videoPlayButtonImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        resetView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    private func setupView() {
        imvMain.contentMode = .scaleAspectFit
        let selfType        = type(of: self)
        imvPlay.image       = selfType.videoPlayButtonImage
    }
    
    private func resetView() {
        imvMain.image       = nil
        imvPlay.isHidden    = true
    }
    
    func bindData(_ data: VIMetadataProtocol?) {
        guard let _data = data else { return }
        
        // Show preview image for video
        if let type = _data.mimeType, type == "video/mp4" {
            imvPlay.isHidden = false
            
            if let imagePath = _data.previewPath {
                imvMain.sd_setImage(with: imagePath)
            }
            return
        }
        
        // Show original image for image
        if let imagePath = _data.originalPath {
            imvMain.sd_setImage(with: imagePath)
        }
    }
    
}
