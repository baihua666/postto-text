//
//  FontTestViewController.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/23.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

//private let testText = "😅Hgjl我2a3"
//private let testText = "Hg"
//private let testText = "gj"
private let testText = "😅H👨‍👧‍👦👨‍👨‍👦‍👦l我2a3"

class FontTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.addVerticalLine(x: 14)
//        
//        self.addVerticalLine(x: 104)
//        
//        self.addVerticalLine(x: 204)
        
        let space: Int = 20
        var count = Int(self.view.frame.size.height) / space
        for index in 0 ... count {
            self.addHorizonalLine(y: CGFloat(index * space))
        }
        
        count = Int(self.view.frame.size.width) / space
        for index in 0 ... count {
            self.addVerticalLine(x: CGFloat(index * space))
        }
    }
    

    fileprivate func setupUI() {
        self.addTestUI(100, isLabelFront: true)
        self.addTestUI(300, isLabelFront: false)

        
    }
    
    fileprivate func addTestUI(_ top: CGFloat, isLabelFront: Bool) {
        
        let testFont = UIFont(name: AppConfig.fontNameArray[0], size: 100)
        
        let testLabel = UILabel()
        self.view.addSubview(testLabel)
        testLabel.frame = CGRect(x: 10, y: top, width: 100, height: 100)
        testLabel.text = testText
        testLabel.font = testFont
        testLabel.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        testLabel.sizeToFit()
        
        let widthOffset: CGFloat = 13
        let frame = CGRect(x: testLabel.frame.origin.x, y: testLabel.frame.origin.y, width: testLabel.frame.size.width + widthOffset, height: testLabel.frame.size.height)
        testLabel.frame = frame
        
        let textWidth = testLabel.frame.size.width
        let textHeight = testLabel.frame.size.height
        
        let topOffset: CGFloat = 0//testLabel.frame.size.height
        let textEngineView = LEOTextEngineViewV2()
        textEngineView.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        textEngineView.frame = CGRect(x: 10, y: testLabel.frame.origin.y + topOffset, width: textWidth, height: textHeight)
        textEngineView.clipsToBounds = false
        //textEngineView.edgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 15)
        //textEngineView.canvasSize = CGSize(width: self.canvasView.bounds.size.width * 0.9, height: self.canvasView.bounds.size.height*0.9)//CGSize(width: UIScreen.main.bounds.size.width, height: 200)
        //textEngineView.canvasSize = CGSize(width: textWidth, height: textHeight)
        //        textEngineView.canvasBackgroundColor = UIColor.gray.withAlphaComponent(0.3)
        textEngineView.font = testFont
        textEngineView.hasShadow = true
        textEngineView.effect = AppConfig.effectArray[0]
        textEngineView.textColor = UIColor.red
        textEngineView.text = testText
        textEngineView.isWorkOnMainThread = false
        
        textEngineView.linesRectArray = [CGRect(x: 0, y: 0, width: textWidth, height: textHeight)]
        
        self.view.addSubview(textEngineView)
        
        textEngineView.startAnim()
        
        if isLabelFront {
            self.view.bringSubviewToFront(testLabel)
        }
        
        let totalTime = textEngineView.totalTime
        let testVariable = textEngineView.floatVariable(variableName: "testint")
        print("totalTime:\(totalTime)")
        
        let defaultColor = textEngineView.defaultColor()
        print("defaultColor:\(String(describing: defaultColor))")
        
//        testLabel.isHidden = true
    }

    
    fileprivate func addVerticalLine(x: CGFloat) {
        let lineView = UIView()
        lineView.frame = CGRect(x: x, y: 0, width: 0.5, height: self.view.bounds.size.height)
        lineView.backgroundColor = UIColor.red
        self.view.addSubview(lineView)
    }
    
    fileprivate func addHorizonalLine(y: CGFloat) {
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: y, width: self.view.bounds.size.width, height: 0.5)
        lineView.backgroundColor = UIColor.red
        self.view.addSubview(lineView)
    }
}
