//
//  AttribuiteLabel.swift
//  MyGithub
//
//  Created by yang on 16/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import CoreText
import DynamicColor
import CoreGraphics

class AttributeLabel: UIView {

    var layout: AttributeLayout? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var font = UIFont.systemFont(ofSize: 14)
    var color = UIColor(hex: 0x262626)

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override var frame: CGRect {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override var bounds: CGRect {
        didSet {
            self.setNeedsDisplay()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let str = "qweqweqwe"//layout?.repository.description ?? "qweqweqwe"
        // 获取当图形上下文
        let context = UIGraphicsGetCurrentContext()

        /* 画布坐标系修正
         coreText 起初是为OSX设计的，而OSX得坐标原点是左下角，y轴正方向朝上。
         iOS中坐标原点是左上角，y轴正方向向下。
         若不进行坐标转换，则文字从下开始，还是倒着的
         */
        // 设置字形的变换为不变换
        context?.textMatrix = .identity
        // 将画布向上平移
        context?.translateBy(x: 0, y: self.bounds.height)
        // 将画布缩放，x轴不变，y轴为-1，相当于沿着x周旋转180度
        context?.scaleBy(x: 1, y: -1)

        if let layout = layout, let context = context {
            for (index, line) in layout.lines.enumerated() {
                let lineOrigin = layout.lineRects[index].origin;
                context.textPosition = lineOrigin
                CTLineDraw(line, context)

                context.setLineWidth(1)
                context.addRect(layout.lineRects[index])
                context.setStrokeColor(UIColor.red.cgColor)
                context.stroke(layout.lineRects[index])
            }
//            CTFrameDraw(layout.frame, context)
//
//            context.textMatrix = .identity
//            // 将画布向上平移
//            context.translateBy(x: 0, y: self.bounds.height)
//            // 将画布缩放，x轴不变，y轴为-1，相当于沿着x周旋转180度
//            context.scaleBy(x: 1, y: -1)
            return
        }
//        // 图片位置回调
//        let dicPic = ["height": 129, "width": 400]
//        var callBacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1,
//                                               dealloc: { _ in },
//                                               getAscent: { _ -> CGFloat in
//                                                return CGFloat(dicPic["height"]!)
//                                               },
//                                               getDescent: { () -> CGFloat in
//                                                   return 0
//                                               }, getWidth: { () -> CGFloat in
//                                                   return dicPic["width"]
//                                               })
//        let delegate = CTRunDelegateCreate(&callBacks, &dicPic)


        let attributes: [NSAttributedStringKey: Any] = [
                .font: font,
                .foregroundColor: color
        ]
        let attibuteStr = NSAttributedString(string: str,
                                             attributes: attributes)

        // 绘制文本
        // frame工厂，负责生成frame
        let frameSetter = CTFramesetterCreateWithAttributedString(attibuteStr)
        // 创建绘制区域
        let path = CGMutablePath()
        path.addRect(self.bounds)

        let length = attibuteStr.length
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, nil)

        CTFrameDraw(frame, context!)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width > 0 ? size.width : (layout?.width ?? 0)
        let height = size.height > 0 ? size.height : (layout?.height ?? 0)
        return CGSize(width: width, height: height)
    }
}

struct AttributeLayout {
    var lines: [CTLine]
    var letterPaths: [UIBezierPath] = []
    var lineRects: [CGRect] = []
    var letterPositions: [CGPoint] = []

    var frame: CTFrame
    var height: CGFloat = 0
    var width: CGFloat = 0
    init(_ attibuteStr: NSAttributedString, width: CGFloat, lastLine: CTLine? = nil) {
        // 计算高度时使用足够长的高度
        let drawHeight: CGFloat = 1000

        // frame工厂，负责生成frame
        let frameSetter = CTFramesetterCreateWithAttributedString(attibuteStr)
        // 创建绘制区域
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: drawHeight))

        let length = attibuteStr.length
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, nil)
        let linesCFArray = CTFrameGetLines(frame)
        let linesCount = CFArrayGetCount(linesCFArray)
        var lines = [CTLine]()
        var origins = [CGPoint](repeating: .zero, count: linesCount)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)

        self.width = width

        var offset: CGFloat = 1000
        print("===========================lineBounds")
        for lineIndex in 0 ..< linesCount {
            let unmanagedLine: UnsafeRawPointer = CFArrayGetValueAtIndex(linesCFArray, lineIndex)
            let line: CTLine = unsafeBitCast(unmanagedLine, to: CTLine.self)
            lines.append(line)
            let lineOrigin = origins[lineIndex]
            var lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useGlyphPathBounds)
            lineBounds.origin = lineOrigin

            lineRects.append(lineBounds)
            if lineIndex == linesCount - 1 {
                self.width = linesCount > 1 ? width : lineOrigin.x
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var leading: CGFloat = 0

                CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
                log.info(["descent:", descent])
                offset = lineOrigin.y - descent
            }
        }
        lineRects = lineRects.map({ (rect) -> CGRect in
            return CGRect(x: rect.origin.x,
                          y: rect.origin.y - offset,
                          width: rect.width,
                          height: rect.height)
        })

        self.height = drawHeight - offset
        self.lines = lines
        self.frame = frame
        log.info(["lineRects:", self.lineRects])
        log.info(["height:", self.height])
    }
}
