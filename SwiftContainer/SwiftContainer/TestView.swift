//
//  TestView.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/9.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

class TestView: UIView {
    
    lazy var textEngineView: LEOTextEngineView = {
        let textEngineView = LEOTextEngineView()
        textEngineView.clipsToBounds = false
        //textEngineView.edgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 15)
        //textEngineView.canvasSize = CGSize(width: self.bounds.size.width * 0.7, height: self.bounds.size.height*0.7)//CGSize(width: UIScreen.main.bounds.size.width, height: 200)
        textEngineView.canvasSize = CGSize(width: 375, height: 375)
        textEngineView.canvasBackgroundColor = UIColor.red.withAlphaComponent(0.3)
        textEngineView.font = UIFont.systemFont(ofSize: 30)
        self.addSubview(textEngineView)
        return textEngineView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textEngineView.bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width * 0.4, height: self.bounds.size.height*0.4)
        self.textEngineView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let m_font = UIFont.systemFont(ofSize: 34)
//        let shadow = NSShadow()
//        
//        shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
//        shadow.shadowOffset = CGSize(width: 2, height: 2)
//        shadow.shadowBlurRadius = 6
        let shadow = pttGetSystemShadow()
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: m_font, NSAttributedString.Key.shadow: shadow]
        
        let attStrChar = NSAttributedString(string: "😂", attributes: attributes)

        attStrChar.draw(in: rect)
        
        
    }
    

}
