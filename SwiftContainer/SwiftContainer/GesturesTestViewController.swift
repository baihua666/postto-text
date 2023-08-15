//
//  ViewController.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/1.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit




class GesturesTestViewController: BaseViewController {
    
    @IBOutlet weak var canvasView: UIView!
    
    @IBOutlet weak var testView: TestView!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    
    
    var selectedView: LEOTextEngineView!
    
    
    

    
    var isTestEngineView = true
    
    var context: EAGLContext = EAGLContext(api: .openGLES2)!
    
    lazy var textEngineView: LEOTextEngineView = {
        let textEngineView = LEOTextEngineView()
        textEngineView.frame = CGRect(x: 100, y: 50, width: 1100, height: 1050)
        textEngineView.clipsToBounds = false
        //textEngineView.edgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 15)
        //textEngineView.canvasSize = CGSize(width: self.canvasView.bounds.size.width * 0.9, height: self.canvasView.bounds.size.height*0.9)//CGSize(width: UIScreen.main.bounds.size.width, height: 200)
        textEngineView.canvasSize = CGSize(width: 1000, height: 1000)
//        textEngineView.canvasBackgroundColor = UIColor.gray.withAlphaComponent(0.3)
        textEngineView.font = UIFont.systemFont(ofSize: 30)
        textEngineView.hasShadow = true
        self.canvasView.addSubview(textEngineView)
        return textEngineView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        
        self.setupGLView(engingView: self.textEngineView, text: textArray[textIndex])
        self.setupGLView(engingView: self.testView.textEngineView, text: textArray[textIndex + 1])
//
            self.setupGestures(targetView: self.textEngineView)
        
        self.selectedView = self.textEngineView
        
        self.startBtn.setTitle("Stop", for: .normal)
        
        self.engingViewArray.append(self.textEngineView)
        self.engingViewArray.append(self.testView.textEngineView)
        
//        let locale = NSLocale.current
//        let region = locale.regionCode
//        print("viewDidLoad:\(locale),\(region)")
        
        self.view.bringSubviewToFront(self.canvasView)
        self.canvasView.bringSubviewToFront(self.textEngineView)
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func setupGLView(engingView: LEOTextEngineView, text: String) {
        
        engingView.backgroundColor = .clear//UIColor.gray
        engingView.canvasBackgroundColor = .clear//UIColor.gray.withAlphaComponent(0.3)
        engingView.text = text
        engingView.effect = AppConfig.effectArray[effectIndex]
        engingView.textColor = UIColor.white
        engingView.context = self.context
        engingView.hasShadow = true
        engingView.isWorkOnMainThread = false
        engingView.shareDispatchQueue = AppConfig.serialDispatchQueue
//        engingView.font = UIFont(name: "Ruler Volume Outline", size: 30)
        
        engingView.linesRectArray = [CGRect(x: 0, y: 50, width: 150, height: 30), CGRect(x: 0, y: 30, width: 150, height: 30)]
        
        engingView.startAnim()
        
        
        let totalTime = engingView.totalTime
        print("totalTime:\(totalTime)")
        
    }
    
    

    


    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func onStartBtnClicked(_ sender: Any) {
        let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        let isStart = engingView.needAutoUpdateAnim
        if !isStart {
            engingView.startAnim()
            self.startBtn.setTitle("Stop", for: .normal)
        }
        else {
            engingView.stopAnim()
            self.startBtn.setTitle("Start", for: .normal)
        }
        
        
    }
    
    @IBAction func onResetBtnClicked(_ sender: Any) {
//        let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
//        engingView.resetAnim()
        
        for subView in self.engingViewArray {
            subView.resetAnim()
        }
    }
    
    var textArray = ["0123456", "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789", "😅", "THgzfebcdf\n12345", "Hello world!Let's go home\n456", "abcdf", "fdsafdsafdsa", "需要地去夺需要怎么了1231212313131231321321321321321312321321321321"]
    var textIndex = 0
    @IBAction func onTextBtnClicked(_ sender: Any) {
        
        textIndex += 1
        if textIndex == textArray.count {
            textIndex = 0
        }
        let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        engingView.text = textArray[textIndex]
        
    }


    
    
    var effectIndex = 6
    @IBAction func onEffectBtnClicked(_ sender: Any) {
        effectIndex += 1
        if effectIndex == AppConfig.effectArray.count {
            effectIndex = 0
        }
        let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        engingView.effect = AppConfig.effectArray[effectIndex]
        
        print("onEffectBtnClicked:\(engingView.effect)")
    }
    


    @IBAction func onApplyTextBtnClicked(_ sender: Any) {
        self.inputTextView.resignFirstResponder()
        
        let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        engingView.text = self.inputTextView.text
    }
    
    @IBAction func onAddViewBtnClicked(_ sender: Any) {
        let newView = LEOTextEngineView()
        self.view.addSubview(newView)
        newView.frame = self.testView.frame
        self.setupGLView(engingView: newView, text: textArray[textIndex])
        self.setupGestures(targetView: newView)

        self.engingViewArray.append(newView)
    }
    
    /// must be >= 1.0
    var snapX:CGFloat = 1.0
    
    /// must be >= 1.0
    var snapY:CGFloat = 1.0
    
    /// how far to move before dragging
    var threshold:CGFloat = 0.0
    /// drag in the Y direction?
    var shouldDragY = true
    
    /// drag in the X direction?
    var shouldDragX = true
    
    //Gestures
    var targetView: UIView {
        return self.selectedView
    }
    
    func setupGestures(targetView: UIView) {

        let pan = UIPanGestureRecognizer(target:self, action:#selector(GesturesTestViewController.pan(rec:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        targetView.addGestureRecognizer(pan)
        

        
        let pinch = UIPinchGestureRecognizer(target:self, action:#selector(GesturesTestViewController.pinch(gestureRecognizer:)))
        pinch.scale = UIScreen.main.scale
        targetView.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target:self, action:#selector(GesturesTestViewController.rotate(_:)))
        targetView.addGestureRecognizer(rotate)
        
        
    }
    

    
    @objc func pan(rec:UIPanGestureRecognizer) {
        
        let p:CGPoint = rec.location(in: self.view)
        var center:CGPoint = .zero
        
        switch rec.state {
        case .began:
            print("began")
            if let subView = rec.view as? LEOTextEngineView {
                self.selectedView = subView
                self.view.bringSubviewToFront(subView)
            }
            
            
        case .changed:
            center = self.targetView.center
            let distance = sqrt(pow((center.x - p.x), 2.0) + pow((center.y - p.y), 2.0))
            print("distance \(distance) threshold \(threshold)")
            
            
            if distance > threshold {
                if shouldDragX {
                    self.targetView.center.x = p.x - (p.x.truncatingRemainder(dividingBy: snapX))
                }
                if shouldDragY {
                    self.targetView.center.y = p.y - (p.y.truncatingRemainder(dividingBy: snapY))
                }
            }
            self.targetView.layoutSubviews()

            
        case .ended:
            print("ended")
            
        case .possible:
            print("possible")
        case .cancelled:
            print("cancelled")
            selectedView = nil
        case .failed:
            print("failed")
            selectedView = nil
        }
    }
    
    @objc func pinch(gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            self.targetView.transform = self.targetView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            gestureRecognizer.scale = 1
            self.targetView.layoutSubviews()
        }
    }
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            
//            print("gestureRecognizer.rotation:\(gestureRecognizer.rotation)")
            self.targetView.transform = self.targetView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
            
        }
        
        let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        //engingView.angle = gestureRecognizer.rotation
        
        //            self.targetView.layoutSubviews()
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            engingView.stopAnim()
        }
        else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            engingView.startAnim()
        }
        
        print("gestureRecognizer.state:\(gestureRecognizer.state.rawValue)")
    }

}

extension UIViewController : UITextViewDelegate {

    
    public func textViewDidEndEditing(_ textView: UITextView) {
//        textView.resignFirstResponder()
    }
}

