//
//  BaseViewController.swift
//  SwiftContainer
//
//  Created by yyf on 2017/4/18.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var engingViewArray: [LEOTextEngineView] = []
    
    var lastUpdateTime: TimeInterval = 0
    var timeSinceLastUpdate: TimeInterval = 0
    
    var preferredFramesPerSecond: Int = 0 {
        didSet {
            self.displayLink.frameInterval = max(1, 60 / preferredFramesPerSecond)
        }
    }
    
    lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(self.drawView))
        displayLink.frameInterval = max(1, 60 / self.preferredFramesPerSecond)
        displayLink.add(to: RunLoop.current, forMode:RunLoop.Mode.common)
        return displayLink
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.preferredFramesPerSecond = 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func drawView() {
        self.update()
        //let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        //engingView.display()
        
        for subView in self.engingViewArray {
            subView.display()
        }
        //self.textEngineView.display()
        //self.testView.textEngineView.display()
    }
    
    
    
    
    func update() {
        //let engingView: LEOTextEngineView = self.isTestEngineView ? self.textEngineView : self.testView.textEngineView
        let nowTime = NSDate().timeIntervalSince1970
        if self.lastUpdateTime == 0 {
            self.timeSinceLastUpdate = 0
        }
        else {
            self.timeSinceLastUpdate = max(nowTime - self.lastUpdateTime, 0)
        }
        self.lastUpdateTime = nowTime
        
        for subView in self.engingViewArray {
            subView.animElapseTime(ms: UInt32(self.timeSinceLastUpdate * 1000))
        }
        
        //self.textEngineView.animElapseTime(ms: UInt32(self.timeSinceLastUpdate * 1000))
        //self.testView.textEngineView.animElapseTime(ms: UInt32(self.timeSinceLastUpdate * 1000))
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
