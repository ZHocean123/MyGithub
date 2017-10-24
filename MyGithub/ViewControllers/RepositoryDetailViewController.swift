//
//  RepositoryDetailViewController.swift
//  MyGithub
//
//  Created by yang on 24/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class RepositoryDetailViewController: UIViewController {

    var repository: Repository?

    let scrollView = NoDelayScrollView()
    let contentView = UIView()
    /// repo描述
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    /// 按钮组
    lazy var buttonContentView: ButtonContentView = {
        return ButtonContentView()
    }()

    /// source组
    lazy var codeContentView: CodeContentView = {
        return CodeContentView()
    }()

    /// readme组
    lazy var readMeView: ReadMeView = {
        return ReadMeView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(buttonContentView)
        contentView.addSubview(codeContentView)
        contentView.addSubview(readMeView)

        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        buttonContentView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(40)
        }
        codeContentView.snp.makeConstraints { (make) in
            make.top.equalTo(buttonContentView.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        readMeView.snp.makeConstraints { (make) in
            make.top.equalTo(codeContentView.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-10)
        }

        descriptionLabel.text = repository?.description
        codeContentView.brunchButton.setTitle(repository?.defaultBranch, for: .normal)

        if let url = repository?.htmlUrl {
            readMeView.webView.load(URLRequest(url: url))
        }
        title = repository?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupSubViews() {

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    class ButtonContentView: UIView {
        let sepline1 = CALayer()
        let sepline2 = CALayer()
        /// watch按钮
        let watchButton = CellButton(type: .custom)

        /// star按钮
        let starButton = CellButton(type: .custom)

        /// fork按钮
        let forkButton = CellButton(type: .custom)

        override init(frame: CGRect) {
            super.init(frame: frame)

            starButton.setImage(#imageLiteral(resourceName: "star.png"), for: .normal)
            forkButton.setImage(#imageLiteral(resourceName: "fork.png"), for: .normal)

            addSubview(watchButton)
            addSubview(starButton)
            addSubview(forkButton)

            sepline1.backgroundColor = borderColor.cgColor
            sepline2.backgroundColor = borderColor.cgColor
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = CGFloatFromPixel(1)
            layer.cornerRadius = 3
            layer.masksToBounds = true
            layer.addSublayer(sepline1)
            layer.addSublayer(sepline2)

            watchButton.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.bottom.equalTo(self)
            }
            starButton.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(watchButton.snp.right)
                make.bottom.equalTo(self)
                make.width.equalTo(watchButton)
            }
            forkButton.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(starButton.snp.right)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
                make.width.equalTo(watchButton)
            }
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            sepline1.frame = CGRect(x: frame.width / 3,
                                    y: 0,
                                    width: CGFloatFromPixel(1),
                                    height: frame.height)
            sepline2.frame = CGRect(x: frame.width / 3 * 2,
                                    y: 0,
                                    width: CGFloatFromPixel(1),
                                    height: frame.height)
        }
    }

    class CodeContentView: UIView {
        /// brunch按钮
        let brunchButton = CellButton(type: .custom)

        /// source按钮
        let sourceButton = CellButton(type: .custom)

        let sepline1 = CALayer()
        let sepline2 = CALayer()
        override init(frame: CGRect) {
            super.init(frame: frame)

            addSubview(brunchButton)
            addSubview(sourceButton)

            sepline1.backgroundColor = borderColor.cgColor
            sepline2.backgroundColor = borderColor.cgColor
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = CGFloatFromPixel(1)
            layer.cornerRadius = 3
            layer.masksToBounds = true

            layer.addSublayer(sepline1)
            layer.addSublayer(sepline2)

            brunchButton.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(40)
            }
            sourceButton.snp.makeConstraints { (make) in
                make.top.greaterThanOrEqualTo(brunchButton.snp.bottom).offset(10)
                make.bottom.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(40)
            }
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            sepline1.frame = CGRect(x: 0,
                                    y: brunchButton.frame.maxY,
                                    width: frame.width,
                                    height: CGFloatFromPixel(1))
            sepline2.frame = CGRect(x: 0,
                                    y: sourceButton.frame.minY,
                                    width: frame.width,
                                    height: CGFloatFromPixel(1))
        }
    }

    class ReadMeView: UIView, WKNavigationDelegate {
        /// brunch按钮
        let brunchButton = CellButton(type: .custom)

        let webView = WKWebView()

        var webViewHeight: ConstraintMakerEditable?

        /// source按钮
        let sourceButton = CellButton(type: .custom)

        let sepline1 = CALayer()
        let sepline2 = CALayer()
        override init(frame: CGRect) {
            super.init(frame: frame)

            addSubview(brunchButton)
            addSubview(webView)
            addSubview(sourceButton)

            sepline1.backgroundColor = borderColor.cgColor
            sepline2.backgroundColor = borderColor.cgColor
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = CGFloatFromPixel(1)
            layer.cornerRadius = 3
            layer.masksToBounds = true

            layer.addSublayer(sepline1)
            layer.addSublayer(sepline2)

            brunchButton.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(40)
            }
            webView.snp.makeConstraints { (make) in
                make.top.greaterThanOrEqualTo(brunchButton.snp.bottom)
                make.left.equalTo(self)
                make.right.equalTo(self)
                webViewHeight = make.height.greaterThanOrEqualTo(40)
            }
            sourceButton.snp.makeConstraints { (make) in
                make.top.greaterThanOrEqualTo(webView.snp.bottom)
                make.bottom.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(40)
            }

            webView.navigationDelegate = self
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            sepline1.frame = CGRect(x: 0,
                                    y: brunchButton.frame.maxY,
                                    width: frame.width,
                                    height: CGFloatFromPixel(1))
            sepline2.frame = CGRect(x: 0,
                                    y: sourceButton.frame.minY,
                                    width: frame.width,
                                    height: CGFloatFromPixel(1))
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)") { [weak self] (result, error) in
                if error == nil, let height = result as? CGFloat {
                    self?.webViewHeight?.constraint.update(offset: height)
                }
            }
        }
    }
}
