//
//  ScaleTestViewViewController.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/24.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit


private let testText = "Hgaf"//"Hg"

class ScaleTestViewViewController: UIViewController {
    
    var canvasView: UIView!
    
    var testLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addCanvasView()
        self.addView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCanvasView() {
        let canvasView = UIView()
        self.view.addSubview(canvasView)
        
        let space: CGFloat = 7
        let canvasWidth = UIScreen.main.bounds.size.width - space * 2
        canvasView.frame = CGRect(x: 10, y: 64 + space, width: canvasWidth, height: canvasWidth)
        
        canvasView.backgroundColor = UIColor.gray
        
        self.canvasView = canvasView
    }
    

    func addView() {
//        let testLabel = UILabel()
//        self.canvasView.addSubview(testLabel)
//        testLabel.text = testText
//        testLabel.sizeToFit()
//        
//        let textWidth = testLabel.frame.size.width
//        let textHeight = testLabel.frame.size.height
//        
//        self.testLabel = label
        
        let newView = LEOTextEngineViewV2()
        newView.canvasView = self.canvasView
        self.canvasView.addSubview(newView)
        newView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.setupGLView(engingView: newView, text: testText)
        self.setupGestures(targetView: newView)
        
        //newView.backgroundColor  = UIColor.red
        
        
        
    }
    
    func setupGLView(engingView: LEOTextEngineView, text: String) {
        
        engingView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        engingView.canvasBackgroundColor = .clear//UIColor.green.withAlphaComponent(0.1)
        engingView.text = text
        engingView.effect = AppConfig.effectArray[0]
        engingView.textColor = UIColor.white
//        engingView.context = self.context
        engingView.hasShadow = true
        engingView.isWorkOnMainThread = false
        //        engingView.font = UIFont(name: "Ruler Volume Outline", size: 30)
        
        engingView.linesRectArray = [CGRect(x: 0, y: 0, width: 150, height: 30), CGRect(x: 0, y: 30, width: 150, height: 30)]
        
        engingView.startAnim()
        
        
        let totalTime = engingView.totalTime
        print("totalTime:\(totalTime)")
        
    }
    
    
    /// how far to move before dragging
    var threshold:CGFloat = 0.0
    
    /// must be >= 1.0
    var snapX:CGFloat = 1.0
    
    /// must be >= 1.0
    var snapY:CGFloat = 1.0

}

//Gestures
extension ScaleTestViewViewController {
    
    func setupGestures(targetView: UIView) {
        
        let pan = UIPanGestureRecognizer(target:self, action:#selector(pan(rec:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        targetView.addGestureRecognizer(pan)
        
        
        
        let pinch = UIPinchGestureRecognizer(target:self, action:#selector(pinch(gestureRecognizer:)))
        pinch.scale = UIScreen.main.scale
        targetView.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target:self, action:#selector(rotate(_:)))
        targetView.addGestureRecognizer(rotate)
        
        
        
    }
    
    
    
    @objc func pan(rec:UIPanGestureRecognizer) {

        guard let subView = rec.view as? LEOTextEngineViewV2 else {
            return
        }


        switch rec.state {
        case .began:
            print("began")



        case .changed:

            let offset = rec.translation(in:subView)



            subView.center.x += offset.x

            subView.center.y += offset.y


            subView.layoutSubviews()
            subView.updateCurrentTextAnim()
            subView.display()



        case .ended:
            print("ended")

        case .possible:
            print("possible")
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        }

        rec.setTranslation(CGPoint.zero, in: subView)
    }
    
    @objc func pinch(gestureRecognizer: UIPinchGestureRecognizer) {
        guard let subView = gestureRecognizer.view as? LEOTextEngineViewV2 else {
            return
        }
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            gestureRecognizer.scale = 1
        }
        
        if gestureRecognizer.state == UIGestureRecognizer.State.changed {
            //let transform = subView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            //let scale = gestureRecognizer.scale - UIScreen.main.scale
            
            let scale = gestureRecognizer.scale
            subView.bounds = CGRect(x: 0, y: 0, width: subView.bounds.width * scale, height: subView.bounds.height * scale)
            subView.center = subView.center
            
            subView.stopAnim()
            
            let font = subView.currentFont
            let newFont = UIFont(name: font.fontName, size: font.pointSize * scale)!
            subView.font = newFont
            
            print("gestureRecognizer, scale=:\(gestureRecognizer.scale), bounds:\(subView.bounds), fontSize:\(newFont.pointSize)")
            
            subView.startAnim()
            subView.display()
            
            gestureRecognizer.scale = 1
        }
    }
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let subView = gestureRecognizer.view as? LEOTextEngineViewV2 else {
            return
        }

        
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            
            //            print("gestureRecognizer.rotation:\(gestureRecognizer.rotation)")
            subView.transform = subView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
            
        }
        
    }
}
