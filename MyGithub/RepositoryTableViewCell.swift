//
//  RepositoryTableViewCell.swift
//  MyGithub
//
//  Created by yang on 11/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import CoreText
import SwiftyImage
import DynamicColor
import QuartzCore

let SINGLE_LINE_WIDTH = (1 / UIScreen.main.scale)
let SINGLE_LINE_ADJUST_OFFSET = ((1 / UIScreen.main.scale) / 2)
let borderColor = DynamicColor(hex: 0xe0e0e0)

struct CellBackground {
    static let image: UIImage = {
        let clearImage = UIImage.size(CGSize(width: 1, height: 12)).color(.clear).image
        let image = UIImage.size(CGSize(width: 1, height: 2))
            .color(.white).image
        return (clearImage + image).stretchableImage(withLeftCapWidth: 0, topCapHeight: 6)
    }()
    static let highlightImage: UIImage = {
        let clearImage = UIImage.size(CGSize(width: 1, height: 12)).color(.clear).image
        let image = UIImage.size(CGSize(width: 1, height: 2))
            .color(DynamicColor(hex: 0xefefef)).image
        return (clearImage + image).stretchableImage(withLeftCapWidth: 0, topCapHeight: 6)
    }()
}

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionView: AttributeLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageButton: CellButton!
    @IBOutlet weak var starsButton: CellButton!
    @IBOutlet weak var forksButton: CellButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundView = UIImageView(image: CellBackground.image)
        self.selectedBackgroundView = UIImageView(image: CellBackground.highlightImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

let screenScale = UIScreen.main.scale
func CGFloatFromPixel(_ pixel: CGFloat) -> CGFloat {
    return pixel / screenScale
}

class CellContentView: UIView {
    let topline = createBorderLine()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addSublayer(topline)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topline.frame = CGRect(x: 0,
                               y: 0,
                               width: self.frame.width,
                               height: CGFloatFromPixel(1))
    }
}

func createBorderLine() -> CALayer {
    let layer = CALayer()
    layer.backgroundColor = borderColor.cgColor
    return layer
}

class CellStatusView: UIView {
    let topline = createBorderLine()
    let bottomline = createBorderLine()
    let sepline1 = createBorderLine()
    let sepline2 = createBorderLine()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addSublayer(topline)
        self.layer.addSublayer(bottomline)
        self.layer.addSublayer(sepline1)
        self.layer.addSublayer(sepline2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topline.frame = CGRect(x: 10,
                               y: 0,
                               width: self.frame.width - 20,
                               height: CGFloatFromPixel(1))
        bottomline.frame = CGRect(x: 0,
                                  y: self.frame.height - CGFloatFromPixel(1),
                                  width: self.frame.width,
                                  height: CGFloatFromPixel(1))
        sepline1.frame = CGRect(x: self.frame.width / 3,
                                y: 5,
                                width: CGFloatFromPixel(1),
                                height: self.frame.height - 10)
        sepline2.frame = CGRect(x: self.frame.width / 3 * 2,
                                y: 5,
                                width: CGFloatFromPixel(1),
                                height: self.frame.height - 10)
    }
}

class CellButton: UIButton {
    static let backgroundImageHighlight = UIImage.size(CGSize(width: 1, height: 1))
        .color(DynamicColor(hex: 0xefeff4)).image
    static let backgroundImage = UIImage.size(CGSize(width: 1, height: 4))
        .color(.clear).image
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBackgroundImage(CellButton.backgroundImage, for: .normal)
        self.setBackgroundImage(CellButton.backgroundImage, for: .disabled)
        self.setBackgroundImage(CellButton.backgroundImageHighlight, for: .highlighted)
    }
}

let screenWidth = UIScreen.main.bounds.width

struct RepositoryTableViewCellLayout {
    var repository: Repository {
        didSet {
            cellHeight =
                getHeight(repository.name,
                          attributes: [.font: UIFont.systemFont(ofSize: 17)],
                          width: screenWidth - 26)
                + getHeight(repository.description,
                            attributes: [.font: UIFont.systemFont(ofSize: 14)],
                            width: screenWidth - 26)
                + 30 + 10
        }
    }
    var layout: AttributeLayout
    var cellHeight: CGFloat = 44

    init(_ repository: Repository) {
        self.repository = repository
        layout = AttributeLayout(NSAttributedString(string: repository.description ?? "", attributes: [.font: UIFont.systemFont(ofSize: 14)]), width: screenWidth - 10)
        cellHeight =
            getHeight(repository.name,
                      attributes: [.font: UIFont.systemFont(ofSize: 17)])
            + layout.height
            + 30 + 15 + 10
    }
}

func getHeight(_ string: String?,
               attributes: [NSAttributedStringKey: Any]? = nil,
               width: CGFloat = screenWidth) -> CGFloat {
    let attributedString = NSAttributedString(string: string ?? "", attributes: attributes)
    return getHeight(attributedString, width: width)
}

func getHeight(_ attributedString: NSAttributedString,
               width: CGFloat = screenWidth) -> CGFloat {
    var height: CGFloat = 0
    let bounds = CGRect(x: 0, y: 0, width: width, height: 1000)
    let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
    let textPath = CGPath(rect: bounds, transform: nil)
    let textFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), textPath, nil)

    let lines = CTFrameGetLines(textFrame)
    var origins = [CGPoint](repeating: .zero, count: CFArrayGetCount(lines))
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), &origins)

    let linesCount = CFArrayGetCount(lines)
    guard linesCount > 0 else {
        return 0
    }
    let endPointY = origins[linesCount - 1].y

    var ascent: CGFloat = 0
    var descent: CGFloat = 0
    var leading: CGFloat = 0

    let unmanagedLine: UnsafeRawPointer = CFArrayGetValueAtIndex(lines, linesCount - 1)
    let line: CTLine = unsafeBitCast(unmanagedLine, to: CTLine.self)

    CTLineGetTypographicBounds(line, &ascent, &descent, &leading)

    height = 1000 - endPointY + descent

    return height
}

