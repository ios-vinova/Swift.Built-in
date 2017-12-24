//
//  VIMetadataVC.swift
//  Hooha-M
//
//  Created by Nea on 12/12/17.
//  Copyright © 2017 Vinova. All rights reserved.
//

import UIKit

class VIMetadataVC: UIViewController,
    UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,
    VIMetadataVCProtocol {

    @IBOutlet weak var clvMain      : UICollectionView!
    @IBOutlet weak var btnPrevious  : UIButton!
    @IBOutlet weak var btnNext      : UIButton!
    
    private var metadataList            : [VIMetadataProtocol] = []
    private var videoPlayButtonImage    : UIImage?
    
    private var currentPage: Int = 0 {
        didSet {
            if currentPage > 0 && currentPage < metadataList.count - 1 {
                btnPrevious.isHidden    = false
                btnNext.isHidden        = false
            } else if currentPage > 0 && currentPage == metadataList.count - 1 {
                btnPrevious.isHidden    = false
                btnNext.isHidden        = true
            } else if currentPage == 0 && metadataList.count > 1 {
                btnPrevious.isHidden    = true
                btnNext.isHidden        = false
            } else {
                btnPrevious.isHidden    = true
                btnNext.isHidden        = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        automaticallyAdjustsScrollViewInsets            = false
        navigationController?.navigationBar.isHidden    = true
        btnPrevious.setImage(#imageLiteral(resourceName: "Previous_Photo"), for: .normal)
        btnNext.setImage(#imageLiteral(resourceName: "Next_Photo"), for: .normal)
        btnNext.isHidden        = true
        btnPrevious.isHidden    = true
        
        configuteCollectionView()
        customBackButton()
    }
    
    @IBAction func didPressNextButton(_ sender: Any) {
        didMoveTo(page: currentPage + 1)
    }
    
    @IBAction func didPressPreviousButton(_ sender: Any) {
        didMoveTo(page: currentPage - 1)
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        navigationController?.navigationBar.isHidden = false
        goto(type: .pop)
    }
    
    func didMoveTo(page: Int) {
        guard page >= 0 && page < metadataList.count else { return }
        
        currentPage = page
        let targetOffsetX = clvMain.frame.size.width * CGFloat(currentPage)
        clvMain.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
    }
    
    // MARK - Collection View
    func configuteCollectionView() {
        clvMain.delegate    = self
        clvMain.dataSource  = self
        clvMain.register(cellType: VIMetadataCell.self, registerType: ._nib)
        VIMetadataCell.videoPlayButtonImage = videoPlayButtonImage
        clvMain.backgroundColor = UIColor.black
        layoutCollectionView()
    }
    
    func layoutCollectionView() {
        let layout = clvMain.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection          = .horizontal
        layout.minimumLineSpacing       = 0
        layout.minimumInteritemSpacing  = 0
        clvMain.isPagingEnabled         = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentPage = 0
        return metadataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        guard index >= 0 && index < metadataList.count else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeue(cellType: VIMetadataCell.self, for: indexPath)
        cell.bindData(metadataList[index])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = indexPath.row
        guard index >= 0 && index < metadataList.count else { return }
        
        if let type = metadataList[index].mimeType, type == "video/mp4",
            let videoPath = metadataList[index].originalPath, let videoURL = URL(string: videoPath) {
            
            // Implement PlayerVC if needed
            CPHelper.showVideo(fileUrl: videoURL)
        }
    }
    
    // MARK: <UIScrollViewDelegate>
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            currentPage = scrollView.currentPage - 1
            didMoveTo(page: currentPage)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = scrollView.currentPage - 1
        didMoveTo(page: currentPage)
    }
    
    static func instantiateFromNib(with dataList: [VIMetadataProtocol], playButtonImage: UIImage?) -> VIMetadataVC? {
        let selfVC                  = VIMetadataVC.instantiateFromNib()
        selfVC.metadataList         = dataList
        selfVC.videoPlayButtonImage = playButtonImage
        return selfVC
    }
}


