//
//  OptionViewController.swift
//  Builder
//
//  Created by Nea on 9/16/17.
//  Copyright © 2017 Vinova. All rights reserved.
//

import UIKit

class OptionActionView {
    private(set) var title: String?
    private(set) var action: (() -> ())!
    
    init (title: String?, action: @escaping () ->()) {
        self.title = title
        self.action = action
    }
}

class OptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tbvOptions: UITableView!
    
    private weak var viewKeeper: UIView?
    private var senderFrame: CGRect?
    
    private var isViewShowing: Bool!
    private var isViewChanged: Bool!
    
    private var actionViews: [OptionActionView]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init?(_ sender: UIView!) {
        self.init(nibName: nil, bundle: nil)
        
        senderFrame     = sender.frame
        actionViews     = [OptionActionView]()
        isViewShowing   = false
        isViewChanged   = false
        
        tbvOptions = UITableView(frame: .zero)
        tbvOptions.delegate = self
        tbvOptions.dataSource = self
        tbvOptions.isScrollEnabled = false
        tbvOptions.register(UITableViewCell.self, forCellReuseIdentifier: "OptionViewCell")
        view.addSubview(tbvOptions)
    }
    
    private func drawView() {
        guard let _senderFrame = senderFrame else { return }
        let _senderKeeperX          = _senderFrame.minX
        let _senderKeeperY          = _senderFrame.maxY + 25
        let _senderKeeperHalfWidth  = _senderFrame.width / 2
        
        let startPoint  = CGPoint(x: _senderKeeperX + _senderKeeperHalfWidth - 5, y: _senderKeeperY + 5)
        let midPoint    = CGPoint(x: _senderKeeperX + _senderKeeperHalfWidth,     y: _senderKeeperY)
        let endPoint    = CGPoint(x: _senderKeeperX + _senderKeeperHalfWidth + 5, y: _senderKeeperY + 5)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer          = CAShapeLayer()
        shapeLayer.path         = path.cgPath
        shapeLayer.strokeColor  = UIColor.white.cgColor
        shapeLayer.fillColor    = UIColor.white.cgColor
        shapeLayer.lineWidth    = 1.0
        self.view.layer.addSublayer(shapeLayer)
        self.view.layoutIfNeeded()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? actionViews.count : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionViewCell", for: indexPath)
        cell.textLabel?.text = actionViews[indexPath.row].title
        return cell
    }
    
    func addAction(_ action: OptionActionView) {
        actionViews.append(action)
        isViewChanged = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionViews[indexPath.row].action()
        hide()
    }
    
    func show(on _view: UIView) {
        guard !isViewShowing, !actionViews.isEmpty, let _senderFrame = senderFrame,
            let rootView = UIApplication.shared.delegate?.window??.rootViewController?.view else { return }
        
        isViewShowing = true
        if isViewChanged {
            let finalSize           = CGSize(width: 200, height: 44 * actionViews.count)
            let finalOrigin         = CGPoint(x: rootView.frame.width - 200, y: _senderFrame.maxY + 20)
            view.frame              = rootView.frame
            
            tbvOptions.frame = CGRect(x: finalOrigin.x, y: finalOrigin.y + 10, width: finalSize.width, height: finalSize.height - 10)
            tbvOptions.layer.cornerRadius = 4
            tbvOptions.reloadData()
            
            drawView()
        }
        
        self.viewKeeper = _view
        self.viewKeeper?.backgroundColor = UIColor.black
        self.viewKeeper?.alpha = 0.5
        rootView.addSubview(self.view)
        isViewChanged = false
    }
    
    func hide() {
        self.viewKeeper?.backgroundColor = UIColor.white
        self.viewKeeper?.alpha = 1
        self.view.removeFromSuperview()
        isViewShowing = false
    }
}
