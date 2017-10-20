//
//  RepositoryViewController.swift
//  MyGithub
//
//  Created by yang on 16/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {

    var repository: Repository?
    // repo分类导航
    let repoNavView = UIView()
    // contentView
    let contentView = UIScrollView()
    // repo描述
    let descriptionLabel = UILabel()
    // topics
    let topicsView = UIView()
    // stars
    let starButton = UIButton()
    // watch
    let watchButton = UIButton()
    // branch
    let branchView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(repoNavView)
        view.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(topicsView)
        contentView.addSubview(starButton)
        contentView.addSubview(watchButton)
        contentView.addSubview(branchView)

        view.backgroundColor = UIColor.white
        repoNavView.backgroundColor = UIColor.gray
        contentView.layer.borderWidth = 3

        descriptionLabel.numberOfLines = 0
        starButton.layer.borderWidth = 3
        watchButton.layer.borderWidth = 3
        
        descriptionLabel.text = repository?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let statusBarHeight: CGFloat = prefersStatusBarHidden ? 0 : 20
        let navHeight = navigationController?.navigationBar.frame.height ?? 0
        repoNavView.frame = CGRect(x: 0,
                                   y: navHeight + statusBarHeight,
                                   width: view.bounds.width,
                                   height: 40)
        contentView.frame = CGRect(x: 0,
                                   y: repoNavView.frame.maxY,
                                   width: view.bounds.width,
                                   height: view.bounds.height - repoNavView.frame.maxY)
        let descriptionHeight = descriptionLabel.sizeThatFits(CGSize(width: view.bounds.width - 20,
                                                                     height: 1000)).height
        descriptionLabel.frame = CGRect(x: 10,
                                        y: 10,
                                        width: view.bounds.width - 20,
                                        height: descriptionHeight)
        starButton.frame = CGRect(x: 10,
                                  y: descriptionLabel.frame.maxY + 10,
                                  width: view.bounds.width / 2 - 10,
                                  height: 30)
        watchButton.frame = CGRect(x: view.bounds.width / 2,
                                   y: descriptionLabel.frame.maxY + 10,
                                   width: view.bounds.width / 2 - 10,
                                   height: 30)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
