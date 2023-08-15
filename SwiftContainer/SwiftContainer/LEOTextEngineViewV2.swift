//
//  LEOTextEngineViewV2.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/24.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit
import GLKit

//画布大小固定
class LEOTextEngineViewV2: LEOTextEngineView {

    //固定的画布,使用者传进来
    weak public var canvasView: UIView? {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    internal var currentCanvasView : UIView {
        return self.canvasView ?? self
    }

    override var canvasSize: CGSize? {
        get {
            return self.currentCanvasView.frame.size
        }
        set {
            assert(false)
            //super.canvasSize = newValue
        }
    }
    
    //文本
//    override var text: String? {
//        didSet {
//            super.text = self.text
//        }
//    }
//    
//    
//    override var frame: CGRect {
//        didSet {
//            
//        }
//    }
//    
//    override var bounds: CGRect {
//        didSet {
//            
//        }
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let glkViewSize = self.makeGlkViewSize()
        if self.glkView.frame != glkViewSize {
            self.glkView.frame = glkViewSize
        }
    }
    
    override func makeGlkViewSize() -> CGRect {
        var rect = self.currentCanvasView.bounds
        
        rect = self.currentCanvasView.convert(rect, to: self)
        return rect
    }
    
    //GLKVIEW的坐标转换到当前视图坐标
    //替代self.glkView.convert(lineRegion, from: self)
    //直接用，self.glkView.convert(lineRegion, from: self)，会在视图有ROTATE时，转换出错
    override func convertRectToSuperView(_ rect: CGRect) -> CGRect {
        var glkRect = rect
        glkRect.origin.x -= self.glkView.frame.origin.x
        glkRect.origin.y -= self.glkView.frame.origin.y
        return glkRect
    }
}
