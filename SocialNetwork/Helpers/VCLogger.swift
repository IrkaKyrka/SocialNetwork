//
//  VCLogger.swift
//  SocialNetwork
//
//  Created by Ira Golubovich on 1/7/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit


class VCLogger: UITableViewController{
    
    private struct LogginGlobals {
        
        var prefix = ""
        var instanceCount = Dictionary<String, Int>()
        var lastLogginDate = Date()
        var intervalForCreation: TimeInterval = 1
        var separator = "____________"
        
    }
    
    private static var logGlobs = LogginGlobals()
    
    static func logPrefix(for className: String) -> String {
        if logGlobs.lastLogginDate.timeIntervalSinceNow < logGlobs.intervalForCreation {
            logGlobs.prefix += logGlobs.separator
        }
        logGlobs.lastLogginDate = Date()
        
        return logGlobs.prefix + className
    }
    
    private static func instanseCount(for className: String) -> Int{
        logGlobs.instanceCount[className] =  logGlobs.instanceCount[className] ?? 0 + 1
        return logGlobs.instanceCount[className]!
    }
    private var instanceCount: Int!
    
    private func logVCL(_ msg: String) {
        let className = String(describing: type(of: self))
        
        if instanceCount == nil {
            instanceCount = VCLogger.instanseCount(for: className)
        }
        
        print("\(VCLogger.logPrefix(for: className)) \(instanceCount) \(msg)")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logVCL("init(coder: ) - initiated view IB")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        logVCL("leave the stack")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logVCL("awakeFromNib Method")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logVCL("viewDidLoad Method")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logVCL("viewWillAppear Method")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logVCL("viewDidAppear Method")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logVCL("viewWillLayoutSubviews Method")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logVCL("viewDidLayoutSubviews Method")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        logVCL("viewWillDisappear Method")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        logVCL("viewDidDisappear Method")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        logVCL("viewWillTransition Method")
    }
}
