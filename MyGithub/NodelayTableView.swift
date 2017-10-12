//
//  NodelayTableView.swift
//  MyGithub
//
//  Created by yang on 12/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit

class NodelayTableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    func commonInit() {
        self.delaysContentTouches = false
        self.canCancelContentTouches = true
        self.separatorStyle = .none

        if let wrapView = self.subviews.first,
            type(of: wrapView).description().hasSuffix("WrapperView") {
            for gesture in wrapView.gestureRecognizers ?? [] where type(of: wrapView).description().contains("DelayedTouchesBegan") {
                gesture.isEnabled = false
                break
            }
        }
    }
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIControl.self) {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
