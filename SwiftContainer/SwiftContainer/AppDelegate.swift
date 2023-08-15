//
//  AppDelegate.swift
//  SwiftContainer
//
//  Created by yyf on 2017/3/1.
//  Copyright © 2017年 leo. All rights reserved.
//

import UIKit

private let textEffectBundleDirName = "effects"

private let fontBundleDirName = "fonts"

private let docEffectFilesPathComponent = "TextEffect"

private let docFontFilesPathComponent = "Fonts"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    let baseFilePath: String = {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }()
    
    var destEffectPath: String {
        return (self.baseFilePath as NSString).appendingPathComponent(docEffectFilesPathComponent)
    }
    
    var destFontPath: String {
        return (self.baseFilePath as NSString).appendingPathComponent(docFontFilesPathComponent)
    }
    
    
    //将BUNDLE里面的文件拷贝到文档中，保持接口一致，每次版本更新执行一次
    fileprivate func copyFilesToDocment() {
        var bundlePath = (Bundle.main.bundlePath as NSString).appendingPathComponent(textEffectBundleDirName)
        
        var destPath = self.destEffectPath
        if FileManager.default.fileExists(atPath: destPath) {
            try! FileManager.default.removeItem(atPath: destPath)
        }
        try! FileManager.default.copyItem(atPath: bundlePath, toPath: destPath)
        
        
        bundlePath = (Bundle.main.bundlePath as NSString).appendingPathComponent(fontBundleDirName)
        
        destPath = self.destFontPath
        if FileManager.default.fileExists(atPath: destPath) {
            try! FileManager.default.removeItem(atPath: destPath)
        }
        try! FileManager.default.copyItem(atPath: bundlePath, toPath: destPath)
        
        let fontPath = (destPath as NSString).appendingPathComponent("RulerVolumeOutline.ttf")
        self.loadFont(path: fontPath, fontName: "Ruler Volume Outline")
    }

    
    func setupTextEngine() {
        
        
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fontDir =  (docDir as NSString).appendingPathComponent(docFontFilesPathComponent)
        
        let effectDir =  (docDir as NSString).appendingPathComponent(docEffectFilesPathComponent)
        //pttInitialize((fontDir as NSString).utf8String, (effectDir as NSString).utf8String)
        //pttLoadAllEffect()
        
        LEOTextEngineView.initializeTextEngine(fontDir: fontDir, effectDir: effectDir)
    }
    
    //从沙盒动态注册字体信息到系统
    func loadFont(path fontPath: String, fontName: String) -> Bool {
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: fontPath))
        let provider = CGDataProvider(data: data as! CFData)
        
        
        let font = CGFont(provider!)
        var error: Unmanaged<CFError>?
        
        let success = CTFontManagerRegisterGraphicsFont(font!, &error)
        if !success {
            
            if let _ = UIFont(name: fontName, size: 17) {
                return true
            }
            
            //            let cfError = error!.takeUnretainedValue()
            //            let code = CFErrorGetCode(cfError)
            //            let domain = CFErrorGetDomain(cfError)
            //            let userInfo = CFErrorCopyUserInfo(cfError)
            //            let reason = CFErrorCopyFailureReason(cfError)
            
            return false
        }
        
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.copyFilesToDocment()
        
        self.setupTextEngine()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

