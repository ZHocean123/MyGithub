//
//  RepositoryCell.swift
//  MyGithub
//
//  Created by yang on 19/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    // repo图标
    let repoImageView = UIImageView()
    // repo名称
    let repoNameLabel = UILabel()
    // repo描述
    let descriptionLabel = UILabel()
    // stars
    let starsLabel = UILabel()
    // star图标
    let starImageView = UIImageView()
    // topics
    let topicsContainer = UIView()

    var cellLayout: CellLayout? {
        didSet {
            repoImageView.image = #imageLiteral(resourceName: "repo")
            starImageView.image = #imageLiteral(resourceName: "star")
            repoNameLabel.text = cellLayout?.item.name
            descriptionLabel.text = cellLayout?.item.description
            starsLabel.text = String(cellLayout?.item.stargazersCount ?? 0)
            setNeedsLayout()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        repoNameLabel.numberOfLines = 0
        repoNameLabel.textColor = UIColor(hex: 0x586069)
        repoNameLabel.font = UIFont.systemFont(ofSize: 14)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor(hex: 0x586069)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)

        starsLabel.textColor = UIColor(hex: 0x586069)
        starsLabel.font = UIFont.systemFont(ofSize: 11)
        
        contentView.addSubview(repoImageView)
        contentView.addSubview(repoNameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starsLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(topicsContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        repoImageView.frame = CGRect(x: 5, y: 7, width: 16, height: 16)
        starImageView.frame = CGRect(x: bounds.width - 25, y: 8, width: 14, height: 14)
        if let cellLayout = cellLayout {
            repoNameLabel.frame = cellLayout.titleFrame
            starsLabel.frame = cellLayout.starsFrame
            descriptionLabel.frame = cellLayout.descriptionFrame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TopicLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = UIColor(hex: 0xe7f3ff)
        textColor = UIColor(hex: 0x0366d6)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

struct CellLayout {
    var item: Repository
    var titleFrame: CGRect
    var descriptionFrame: CGRect
    var starsFrame: CGRect
//    var topicsFrames: [CGRect]
    var height: CGFloat

    static let cell = RepositoryCell(style: .default, reuseIdentifier: nil)
    static let topicLabel = TopicLabel()

    init(_ item: Repository) {
        self.item = item
        let width = screenWidth
        // starsLabel
        CellLayout.cell.starsLabel.text = String(item.stargazersCount)
        let starsLabelSize = CellLayout.cell.starsLabel
            .sizeThatFits(CGSize(width: width, height: 1000))
        starsFrame = CGRect(x: width - starsLabelSize.width - 30,
                            y: 5,
                            width: starsLabelSize.width,
                            height: 20)
        // repoNameLabel
        CellLayout.cell.repoNameLabel.text = item.name
        let repoNameLabelSize = CellLayout.cell.repoNameLabel
            .sizeThatFits(CGSize(width: starsFrame.minX - 30 - 5,
                                 height: 1000))
        titleFrame = CGRect(x: 30,
                            y: 5,
                            width: repoNameLabelSize.width,
                            height: max(repoNameLabelSize.height, 20))
        // descriptionLabel
        CellLayout.cell.descriptionLabel.text = item.description
        let descriptionLabelSize = CellLayout.cell.descriptionLabel
            .sizeThatFits(CGSize(width: width - 10 - 30, height: 1000))
        descriptionFrame = CGRect(x: 30,
                                  y: titleFrame.maxY + 5,
                                  width: width - 10 - 30,
                                  height: descriptionLabelSize.height)

        height = descriptionFrame.maxY + 5
        // starsLabel
//        for topic in item.t {
//            CellLayout.topicLabel
//        }
//        let starsLabelSize = .starsLabel.sizeThatFits(CGSize(width: width, height: 1000))
//        starsFrame = CGRect(x: width - starsLabelSize.width - 30,
//                            y: 5,
//                            width: starsLabelSize.width,
//                            height: 20)
    }
}
