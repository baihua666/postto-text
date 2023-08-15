//
//  EffectTestViewController.swift
//  SwiftContainer
//
//  Created by yyf on 2017/4/18.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

private let testText = "g123"
private let testLinesText = "g1234567890\ng1234567890\ng1234567890"


class EffectTestViewController: BaseViewController {
    
    var context: EAGLContext = EAGLContext(api: .openGLES2)!
    
    var effectIndex: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.gray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let viewRect = CGRect(x: 100, y: 100, width: 200, height: 300)
            self.addView(frame: viewRect)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func addView(frame: CGRect) {
        let newView = LEOTextEngineViewV2()
        self.view.addSubview(newView)
        newView.frame = frame
        self.setupGLView(engingView: newView)
        
        self.engingViewArray.append(newView)
    }
    
    func setupGLView(engingView: LEOTextEngineView) {
        engingView.backgroundColor = .clear//UIColor.gray
        engingView.canvasBackgroundColor = .clear//UIColor.gray.withAlphaComponent(0.3)
        engingView.effect = AppConfig.effectArray[effectIndex]
        var lineHeight:Int = 50
        if (engingView.effect == "test_lines") {
            engingView.numberOfLines = 3
            engingView.text = testLinesText
            engingView.linesRectArray = [CGRect(x: 0, y: 0, width: 150, height: lineHeight),
                                         CGRect(x: 0, y: lineHeight, width: 150, height: lineHeight * 2),
                                         CGRect(x: 0, y: lineHeight * 2, width: 150, height: lineHeight * 3)]
        }
        else {
            engingView.numberOfLines = 1
            engingView.text = testText
            engingView.linesRectArray = [CGRect(x: 0, y: 0, width: 150, height: lineHeight)]
        }
        
        engingView.textColor = UIColor.white
        engingView.context = self.context
        engingView.hasShadow = true
        engingView.isWorkOnMainThread = false
        engingView.shareDispatchQueue = AppConfig.serialDispatchQueue
        //        engingView.font = UIFont(name: "Ruler Volume Outline", size: 30)
        
//        engingView.linesRectArray = [CGRect(x: 0, y: 0, width: 150, height: 30)]
        
        engingView.startAnim()
        
        
        let totalTime = engingView.totalTime
        let isAutoRepeat = engingView.isAnimAutoRepeat()
        print("effect:\(String(describing: engingView.effect)), totalTime:\(totalTime), isAutoRepeat:\(isAutoRepeat)")
        
    }
}
