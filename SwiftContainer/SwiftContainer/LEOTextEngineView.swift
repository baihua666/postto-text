//
//  LEOTextEngineView.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/1.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit
import Foundation
import GLKit

private let animElapseTimeStart: UInt32 = 0

private let glQueueName = "com.postto.textEngineQueue"
private var glQueueLock:Int = 0

private let serialDispatchQueue:DispatchQueue = {
    return DispatchQueue(label:glQueueName, attributes: [])
}()

class LEOTextEngineView: UIView, GLKViewDelegate {
    
    static let textLineSeparator = "\n"
    
    
    
    var isWorkOnMainThread = true {
        didSet {
            //log.debug()
        }
    }
    
    var shareDispatchQueue: DispatchQueue?
    
    //OPENGL视图
    internal lazy var glkView: GLKView = {
        self.assertMainThread()
        let glkView = GLKView()
        self.addSubview(glkView)
        glkView.frame = self.makeGlkViewSize()
        glkView.delegate = self
        glkView.drawableColorFormat = .RGBA8888
        glkView.drawableDepthFormat = .format24
        glkView.drawableStencilFormat = .format8
        glkView.isUserInteractionEnabled = false
//        glkView.context = EAGLContext(api: .openGLES2)
//        EAGLContext.setCurrent(glkView.context)
        glkView.clipsToBounds = false
        glkView.isOpaque = false
        
        
//        glkView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        return glkView
    }()
    
    //OPENGL 上下文
    var context: EAGLContext? {
        didSet {
            if let context = self.context {
                self.glkView.context = context
            }
        }
    }
    
    //动画对你
    fileprivate var textAnim: pttAnimator? = nil
    
    //文本
    public var text: String? {
        didSet {
            if self.needAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    public var linesRectArray: [CGRect] = [] {
        didSet {
            if self.needAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    //文字颜色
    public var defaultTextColor: UIColor = UIColor.black
    
    public var textColor: UIColor? {
        didSet {
            if self.needAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    //文字背景色
    public var canvasBackgroundColor: UIColor?
    
    //字体
    public var font: UIFont? {
        didSet {
            if self.needAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    public var currentFont: UIFont {
        return self.font ?? UIFont.systemFont(ofSize: self.defaultFontSize)
    }
    
    //特效
    public var effect: String? {
        didSet {
            if self.needAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    public var angle: CGFloat = 0 {
        didSet {
            if self.needAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }

    
    //自动更新动画标记
    //动画开始后，修改属性后会自动重新创建动画，没开始时，只会保存数据而不更新动画，直接开始动画时再创建
    public var needAutoUpdateAnim = false
    
    //动画正在运行的标记
    //fileprivate var isAnimRunning = false
    
    //需要更新动画标记
    fileprivate var needUpdateAnim = false {
        didSet {
            //print("isNeedUpdateAnim")
        }
    }
    
    //默认字体大小
    var defaultFontSize: CGFloat = 50
    //默认特效
    static var defaultEffect: String = "normal"
    
    //最大循环次数
    var maxRepeatCount = 0
    
    
    /// 不能设置太大，否则会导致OPENGL性能消耗变大，内存使用过大导致程序会被系统回收
    public var canvasSize: CGSize? {
        didSet {
            
        }
    }
    //文本对齐方式
    public var textAlignment: NSTextAlignment = .left {
        didSet {
            if self.isNeedAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    var numberOfLines: Int = 1
    
    //内边距
    public var edgeInsets: UIEdgeInsets = .zero
    
    //是否有阴影
    public var hasShadow = false {
        didSet {
            if self.isNeedAutoUpdateAnim {
                self.updateCurrentTextAnim()
            }
            else {
                self.needUpdateAnim = true
            }
        }
    }
    
    //时长
    var totalTime: TimeInterval {
        guard let textAnim = self.textAnim else {
            return 0
        }
        return TimeInterval(pttGetTotalTime(textAnim))/1000.0
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    deinit {
        self.clearAnim()
        
        //log.debug("\(String(describing: self.text))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //清除动画后
    public func clearAnim() {
        self.stopAnim()
        
        guard let textAnim = self.textAnim else {
            return
        }
        
        if self.isWorkOnMainThread {
            pttReleaseAnim(textAnim)
            self.textAnim = nil
        }
        else {
            let dispatchQueue = self.workDispatchQueue()
            let dispatchQueueName = self.name(of: dispatchQueue)
            if let queueName = self.currentQueueName(), queueName == dispatchQueueName {
                EAGLContext.setCurrent(self.glkView.context)
                pttReleaseAnim(textAnim)
                self.textAnim = nil
            }
            else {
                dispatchQueue.sync {
                    pttReleaseAnim(textAnim)
                    self.textAnim = nil
                }
            }
            
        }
        
        //下次START再重新创建动画
        self.needUpdateAnim = true
    }
    
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    

   
    
    internal func makeGlkViewSize() -> CGRect {
        let canvasSize = self.canvasSize ?? self.bounds.size
        let glkFrame = CGRect(x: (self.bounds.size.width - canvasSize.width) / 2, y: (self.bounds.size.height - canvasSize.height) / 2, width: canvasSize.width, height: canvasSize.height)
        return glkFrame
    }
    
    fileprivate func currentQueueName() -> String? {
        let name = __dispatch_queue_get_label(nil)
        return String(cString: name, encoding: .utf8)
    }
    
    fileprivate func name(of dispatchQueue: DispatchQueue) -> String {
        let name = __dispatch_queue_get_label(dispatchQueue)
        return String(cString: name, encoding: .utf8)!
    }
    
    fileprivate func workDispatchQueue() -> DispatchQueue {
        return self.shareDispatchQueue ?? serialDispatchQueue
    }
    
    fileprivate func doOnGLThread(_ action: @escaping (() -> Void)) {
        //temp test
        //return
        if self.isWorkOnMainThread {
            EAGLContext.setCurrent(self.glkView.context)
            self.doOnMainThread(action)
        }
        else {
            let dispatchQueue = self.workDispatchQueue()
            let dispatchQueueName = self.name(of: dispatchQueue)
            if let queueName = self.currentQueueName(), queueName == dispatchQueueName {
                EAGLContext.setCurrent(self.glkView.context)
                action()
            }
            else {
                //异步调用有可能会导致无法正常显示
                dispatchQueue.sync { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.enterSync()
                    EAGLContext.setCurrent(strongSelf.glkView.context)
                    
                    action()
                    strongSelf.exitSync()
                }
            }


        }

    }
    
    fileprivate func doOnMainThread(_ action: @escaping (() -> Void)) {
        if Thread.isMainThread {
            action()
        }
        else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
    
    
    /// 初始化引擎
    ///
    /// - Parameters:
    ///   - fontDir: 字体目录
    ///   - effectDir: 字效目录
    static public func initializeTextEngine(fontDir: String,
                                            effectDir: String) {
        
        pttInitialize((fontDir as NSString).utf8String, (effectDir as NSString).utf8String)
        //pttLoadAllEffect()

    }
    
    
    var isNeedAutoUpdateAnim = false
    
    
    //开始动画
    public func startAnim() {

        self.needAutoUpdateAnim = true
        
//        self.startRun()
        
        if self.needUpdateAnim {
            self.updateCurrentTextAnim()
            self.needUpdateAnim = false
        }
    }
    
    //结束动画
    public func stopAnim() {
        self.needAutoUpdateAnim = false
    }
    
    //重置动画
    public func resetAnim() {
        //log.debug("\(String(describing: self.text))")
        self.doOnGLThread { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.assertGLThread()
            if let textAnim = strongSelf.textAnim {
                pttResetAnim(textAnim)

                pttAnimElapseTime(textAnim, animElapseTimeStart)
            }
        }
        
    }
    
    //显示
    public func display() {
        
        self.doOnGLThread { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.glkView.display()
            
        }
        
            
    }
    
    //获取自定义变量的值
    public func floatVariable(variableName: String) -> Float? {
        guard let effect = self.effect else {
            return nil
        }
        
        var fValue: Float = 0
        if pttGetFloatVariable(effect, variableName, &fValue) != POSTTO_TEXT_ERROR_SUCCESS {
            return nil
        }
        return fValue
    }
    
    //动画是否自动重复
    public func isAnimAutoRepeat() -> Bool {
        guard let autoRepeat = self.floatVariable(variableName: "auto_repeat") else {
            return true
        }
        
        return autoRepeat != 0
    }
    
    
    //默认颜色，当前只有READER字效需要
    public func defaultColor() -> UIColor? {
        guard let defaultColorValut = self.floatVariable(variableName: "default_color") else {
            return nil
        }
        
        return UIColor(hex6: UInt32(defaultColorValut), alpha: 1)
    }


    
//    public func tailingDuration() -> TimeInterval? {
//        guard let tailingDuration = self.floatVariable(variableName: "tailing_duration") else {
//            return nil
//        }
//        
//        return TimeInterval(tailingDuration/1000)
//    }
    
    
    //计算时间偏移
    public func animElapseTime(ms: UInt32) {
        self.doOnGLThread { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.assertGLThread()
            
            guard let textAnim = strongSelf.textAnim else {
                return
            }
            
            if let effect = strongSelf.effect, !effect.isEmpty {
                
                pttAnimElapseTime(textAnim, ms)
            }
            
        }
    }
    
    fileprivate func enterSync() {
        assert(glQueueLock == 0)
        glQueueLock += 1
    }
    
    fileprivate func exitSync() {
        assert(glQueueLock == 1)
        glQueueLock -= 1
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        
        self.glkView.frame = self.makeGlkViewSize()
    }
    
    
//    //开始运行动画
//    fileprivate func startRun() {
//        self.isAnimRunning = true
//    }
//    
//    //停止动画运行
//    fileprivate func stopRun() {
//        if !self.isAnimRunning {
//            return
//        }
//        self.isAnimRunning = false
//    
//    }
    
    //释放当前动画
    fileprivate func releaseCurrentAnim() {
        if self.textAnim != nil {
            self.assertGLThread()
            pttReleaseAnim(self.textAnim)
            self.textAnim = nil
        }
    }
    
    //更新当前动画
    public func updateCurrentTextAnim() {
        if self.glkView.frame != self.makeGlkViewSize() {
            self.doOnMainThread {
                self.layoutSubviews()
            }
        }
        
        if self.context == nil {
            self.context = EAGLContext(api: .openGLES2)
        }
        
        self.doOnGLThread { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.assertGLThread()
            strongSelf.releaseCurrentAnim()
            
            guard let text = strongSelf.text, !text.isEmpty else {
                //设置空后停止，但是并没有再判断开始
                //strongSelf.stopRun()
                return
            }
            
            if strongSelf.needAutoUpdateAnim {
                strongSelf.updateTextAnim(text: text, effect: strongSelf.effect)
            }
            
        }
        
    }
    
    
//    fileprivate func textRegion(with alignment: NSTextAlignment, edgeInsets: UIEdgeInsets) -> CGRect {
//        let insetsRect = self.
//    }
    
    //引擎像素转换,POINT TO PIX
//    fileprivate func engineRect(with rect: CGRect) -> CGRect {
//        let multiply: CGFloat = UIScreen.main.scale
//        return CGRect(x: rect.origin.x * multiply, y: rect.origin.y * multiply, width: rect.width * multiply, height: rect.height * multiply)
//
//    }
    
    //更新动画
    fileprivate func updateTextAnim(text: String, effect: String?) {
        //return
        
        self.assertGLThread()
        let font = self.currentFont
        //let enginFont = UIFont(name: font.fontName, size: font.pointSize)
        
//        shadow.shadowColor = UIColor.black
//        shadow.shadowOffset = CGSize(width: 4, height: 2)
        //let attributes = [NSFontAttributeName: enginFont, NSShadowAttributeName: shadow]
        var attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: font]
        if self.hasShadow {
            let shadow = pttGetSystemShadow()
            attributes[NSAttributedString.Key.shadow] = shadow
        }

        let emptyAttrstr = NSAttributedString(string: "1", attributes: attributes)
        //var region = CGRect(x: 0, y: 0, width: attrstr.size().width, height: attrstr.size().height)
        //var region = self.glkView.bounds
        //视图区域
        let region = self.glkView.bounds
        //视图区域在显示区域的相对位置
        //let regionInSuperView = self.glkView.convert(region, from: self)
        //let regionInSuperView = region
        //计算内边距
        let insetsRegion = region.inset(by: self.edgeInsets)
        
        var section: pttSection? = nil
        var canvasSize = self.glkView.frame.size
//        canvasSize = CGSize(width: canvasSize.width * UIScreen.main.scale, height: canvasSize.height * UIScreen.main.scale)
        
        
        var effectConfig:pttEffectConfig = pttEffectConfig()
        let textColor = self.textColor ?? self.defaultTextColor
        effectConfig.fontConfig.color = UInt32(textColor.rgba()!)      
        effectConfig.fontConfig.flag = 0
        
        if self.hasShadow {
            effectConfig.fontConfig.flag |= POSTTO_TEXT_EFFECT_FLAG_SHADOW
        }
        
        
        var sectionTextRect = insetsRegion

        let errCode = pttCreateSectionFromString(&section, &canvasSize, emptyAttrstr, &sectionTextRect, Float(self.angle), self.effect ?? type(of:self).defaultEffect, &effectConfig)
        if errCode == POSTTO_TEXT_ERROR_EFFECT_NOT_EXIST {
            pttCreateSectionFromString(&section, &canvasSize, emptyAttrstr, &sectionTextRect, Float(self.angle), type(of:self).defaultEffect, &effectConfig)
        }
       
        let lineTextArray = text.components(separatedBy: type(of: self).textLineSeparator)
        let lineCount = min(lineTextArray.count, self.linesRectArray.count)
        for lineIndex in 0 ..< lineCount {
            let lineAttrstr = NSAttributedString(string: lineTextArray[lineIndex], attributes: attributes)
            
            var line:pttLine? = nil
            var lineRegion = linesRectArray[lineIndex]
            
            
            //行区域在显示区域的相对位置
//            lineRegion = self.glkView.convert(lineRegion, from: self)
            lineRegion = self.convertRectToSuperView(lineRegion)
            
            lineRegion.size = lineAttrstr.size()
            
            pttAddLineFromString(section, &line, lineAttrstr, &lineRegion)
            
            pttReleaseLine(line)
            
            print("pttAddLineFromString,lineRegion:\(lineRegion), linesRectArray:\(self.linesRectArray)")
        }
        
//        var line:pttLine? = nil
//        var lineRegion = engineRegionInSuperView
//        lineRegion.size = attrstr.size()
//        pttAddLineFromString(section, &line, attrstr, &lineRegion)
        
        pttCreateAnim(&self.textAnim)
        pttAddSectionToAnim(self.textAnim, section)
        
        pttReleaseSection(section)
        
//        pttReleaseLine(line)
        
        pttStartAnim(self.textAnim)

        pttAnimElapseTime(self.textAnim, 0)
        
        pttRenderAnim(self.textAnim)
        
//        self.display()
        
    }
    
    //GLKVIEW的坐标转换到当前视图坐标
    //替代self.glkView.convert(lineRegion, from: self)
    //直接用，self.glkView.convert(lineRegion, from: self)，会在视图有ROTATE时，转换出错
    internal func convertRectToSuperView(_ rect: CGRect) -> CGRect {
        guard let canvasSize = self.canvasSize else {
            return rect
        }
        var glkRect = rect
        glkRect.origin.x += (canvasSize.width - self.bounds.size.width)/2
        glkRect.origin.y += (canvasSize.height - self.bounds.size.height)/2
        return glkRect
    }
    
    
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//        
//        guard let text = text, !text.isEmpty else {
//            return
//        }
//        
//        if self.textAnim == nil , let text = self.text, let effect = self.effect {
//            if self.isNeedUpdateAnim {
//                self.isNeedUpdateAnim = false
//            }
//            self.updateTextAnim(text: text, effect: effect)
//            
//            if let textAnim = self.textAnim {
//                pttAnimElapseTime(textAnim, animElapseTimeStart)
//            }
//
//        }
//    }
    
    /// GLKViewDelegate
    ///
    /// - Parameters:
    ///   - view: view description
    ///   - rect: rect description

    internal func glkView(_ view: GLKView, drawIn rect: CGRect) {
        if self.isHidden || self.alpha == 0 {
            return
        }
        
        self.doOnGLThread { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            guard let textAnim = strongSelf.textAnim else {
                return
            }
        
        
            if let canvasBackgroundColor = strongSelf.canvasBackgroundColor {
                var fRed : CGFloat = 0
                var fGreen : CGFloat = 0
                var fBlue : CGFloat = 0
                var fAlpha: CGFloat = 0
                if canvasBackgroundColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
                    glClearColor(GLfloat(fRed), GLfloat(fGreen), GLfloat(fBlue), GLfloat(fAlpha))
                    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
                }
            }

            //test
            //for i in 0 ... 10 {
            pttRenderAnim(textAnim)
            //}
        }

    }
    
    public func assertGLThread(_ file: StaticString = #file, line: UInt = #line) {
        if self.isWorkOnMainThread {
            self.assertMainThread()
        }
        else {
            let dispatchQueue = self.workDispatchQueue()
            let dispatchQueueName = self.name(of: dispatchQueue)
            if let queueName = self.currentQueueName() {
                //print("queueName:\(queueName)")
                assert(queueName == dispatchQueueName, "Code at \(file):\(line) must run on GL thread!")
            }
            else {
                assert(false, "Code at \(file):\(line) must run on GL thread!")
            }
        }
    }
    
    public func assertMainThread(_ file: StaticString = #file, line: UInt = #line) {
        assert(Thread.isMainThread, "Code at \(file):\(line) must run on main thread!")
    }
}

internal extension UIColor {
    
    func argb() -> UInt? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = UInt(fRed * 255.0)
            let iGreen = UInt(fGreen * 255.0)
            let iBlue = UInt(fBlue * 255.0)
            let iAlpha = UInt(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let argb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return argb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func rgba() -> UInt? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = UInt(fRed * 255.0)
            let iGreen = UInt(fGreen * 255.0)
            let iBlue = UInt(fBlue * 255.0)
            let iAlpha = UInt(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgba = (iRed << 24) + (iGreen << 16) + (iBlue << 8) + iAlpha
            return rgba
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    internal convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
