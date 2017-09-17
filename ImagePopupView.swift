//
//  CPImagePopupView
//  Complaint
//
//  Created by Nea on 9/1/17.
//  Copyright © 2017 Vinova. All rights reserved.
//

import UIKit

class ImagePopupView: UIView {
    private static var imageView: UIImageView? = nil
    private static var containerView: UIView? = nil
    private static var exitButton: UIButton? = nil
    
    private static var completion: (() -> ())? = nil
    
    private static func configureUIs() {
        let mainBounds = UIScreen.main.bounds
        containerView = UIView(frame: mainBounds)
        containerView?.backgroundColor = UIColor.black
        
        let width: CGFloat = min(mainBounds.width, mainBounds.height)
        imageView = UIImageView(frame: CGRect(x: 0, y: mainBounds.height/2 - width/2, width: width, height: width))
        imageView?.contentMode = .scaleToFill
        
        exitButton = UIButton(frame: CGRect(x: mainBounds.maxX - 24 - 16, y: 40, width: 24, height: 24))
        exitButton?.setImage(UIImage(named: "close"), for: .normal)
        exitButton?.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        containerView?.addSubview(imageView!)
        containerView?.addSubview(exitButton!)
    }
    
    static func show(_ image: UIImage, completion: @escaping () -> ()) {
        if containerView == nil {
            configureUIs()
        }
        guard let rootView = UIApplication.shared.delegate?.window??.rootViewController?.view, let _containerView = containerView, let _imageView = imageView else { return }
        
        _imageView.image = image
        rootView.addSubview(_containerView)
        
        self.completion = completion
    }
    
    static func hide() {
        guard let _containerView = containerView, let _imageView = imageView else { return }
        
        _containerView.removeFromSuperview()
        _imageView.image = nil
        
        guard let _completion = completion else { return }
        _completion()
        completion = nil
    }
}
