//
//  AppConfig.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/23.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

private let glQueueName = "com.postto.textEngineQueueTest"

class AppConfig: NSObject {
    static let effectArray = ["drama", "normal", "typing", "illusion", "outline" //0-4
        , "parallel", "reader", "blur", "vibrate", "disappear", //5-9
                              "jelly", "barrage",
          "test_alpha_anim", "test_composite_anim", "test_glyph_grid", "test_grid", "test_key_tex", "test_lines", "test_load_tex", "test_rotate_anim", "test_tex_anim", "test_trans_anim", "test_y_rotate"]
    
    static let fontNameArray = ["Ruler Volume Outline", "Times-Roman", UIFont.systemFont(ofSize: 18).fontName]
    
    static let serialDispatchQueue:DispatchQueue = {
        return DispatchQueue(label:glQueueName, attributes: [])
    }()
}
