//
//  ShadowTestViewController.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/28.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

private let testText = "Hg"

class ShadowTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func setupUI() {
        self.addTestUI(100, isLabelFront: true)

        
    }
    
    fileprivate func addTestUI(_ top: CGFloat, isLabelFront: Bool) {
        
        let testFont = UIFont(name: AppConfig.fontNameArray[1], size: 50)
        
        let testLabel = UILabel()
        
        testLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        testLabel.layer.shadowOpacity = 1
        testLabel.layer.shadowRadius = 2
        testLabel.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
        
        self.view.addSubview(testLabel)
        testLabel.frame = CGRect(x: 10, y: top, width: 100, height: 100)
        testLabel.text = testText
        testLabel.font = testFont
        //testLabel.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        testLabel.sizeToFit()
        
        let widthOffset: CGFloat = 13
        let frame = CGRect(x: testLabel.frame.origin.x, y: testLabel.frame.origin.y, width: testLabel.frame.size.width + widthOffset, height: testLabel.frame.size.height)
        testLabel.frame = frame
        
        let textWidth = testLabel.frame.size.width
        let textHeight = testLabel.frame.size.height
        
        let topOffset: CGFloat = testLabel.frame.size.height
        let textEngineView = LEOTextEngineViewV2()
        //textEngineView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        textEngineView.frame = CGRect(x: 10, y: testLabel.frame.origin.y + topOffset, width: textWidth, height: textHeight)
        textEngineView.clipsToBounds = false
        //textEngineView.edgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 15)
        //textEngineView.canvasSize = CGSize(width: self.canvasView.bounds.size.width * 0.9, height: self.canvasView.bounds.size.height*0.9)//CGSize(width: UIScreen.main.bounds.size.width, height: 200)
        //textEngineView.canvasSize = CGSize(width: textWidth, height: textHeight)
        //        textEngineView.canvasBackgroundColor = UIColor.gray.withAlphaComponent(0.3)
        textEngineView.font = testFont
        textEngineView.hasShadow = true
        textEngineView.effect = AppConfig.effectArray[1]
        textEngineView.textColor = UIColor.black
        textEngineView.text = testText
        textEngineView.isWorkOnMainThread = false
        
        textEngineView.linesRectArray = [CGRect(x: 0, y: 0, width: textWidth, height: textHeight)]
        
        self.view.addSubview(textEngineView)
        
        textEngineView.startAnim()
        
        if isLabelFront {
            self.view.bringSubviewToFront(testLabel)
        }
        
    }

}
