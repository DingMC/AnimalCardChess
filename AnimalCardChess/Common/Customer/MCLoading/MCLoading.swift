//
//  MCLoading.swift
//  xhy
//
//  Created by masun on 2017/8/7.
//  Copyright © 2017年 dingmc. All rights reserved.
//

import UIKit

class MCLoading: NSObject {
    static let shared = MCLoading()
    
    lazy var loadingView = MCLoadingView()
    
    var target: UIViewController!
    func startLoading(_ target: UIViewController! = nil, text: String = "努力加载中..."){
        self.loadingView.startLoading(text)
        
        if let _ = target{
            self.target = target
            target.view.isUserInteractionEnabled = false
            target.view.addSubview(self.loadingView)
        }else{
            self.loadingView.addToWindows()
        }
        self.loadingView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func stopLoading(_ alertString: String! = nil){
        DispatchQueue.main.async {
            self.target?.view.isUserInteractionEnabled = true
            if alertString != nil{
                self.loadingView.stopLoading(alertString)
                return
            }
            self.loadingView.stopLoading()
        }
    }
    
    func alert(_ text: String){
        DispatchQueue.main.async {
            self.loadingView.alert(text)
        }
    }
}
