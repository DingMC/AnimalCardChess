//
//  MCLoadingView.swift
//  xhy
//
//  Created by masun on 2017/8/7.
//  Copyright © 2017年 dingmc. All rights reserved.
//

import UIKit

class MCLoadingView: UIView {
    
    lazy var activityViewFor = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    lazy var activityBackView = UIView()
    lazy var loadingLabel = UILabel()
    
    var loadingBgColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
        self.createSnp()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    func createView(){
        self.activityBackView.backgroundColor = self.loadingBgColor
        self.activityBackView.layer.cornerRadius = 5
        self.activityBackView.layer.masksToBounds = true
        self.addSubview(self.activityBackView)
        
        self.activityBackView.addSubview(self.activityViewFor)
        
        self.loadingLabel.textColor = UIColor.white
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.font = UIFont.systemFont(ofSize: 12)
        self.activityBackView.addSubview(self.loadingLabel)
    }
    
    //加载中的布局
    func createSnp(){
        self.activityBackView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(120)
            make.center.equalToSuperview()
        }
        self.activityViewFor.snp.remakeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        self.loadingLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(20)
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(self.activityViewFor.snp.bottom)
        }
    }
    
    //只有提示时的布局
    func updateSnp(){
        self.loadingLabel.textAlignment = .center
        self.activityBackView.snp.remakeConstraints { (make) in
            make.width.equalTo(180)
            make.center.equalToSuperview()
        }
        
        self.activityViewFor.snp.remakeConstraints { (make) in
            
        }
        
        self.loadingLabel.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    //停止之前的动画效果
    func removeAnimation(){
        self.layer.removeAllAnimations()
        self.activityBackView.layer.removeAllAnimations()
        self.activityViewFor.layer.removeAllAnimations()
    }
    
    
    //开始加载...
    func startLoading(_ text: String){
        self.removeAnimation()
        self.createSnp()
        self.alpha = 1
        self.loadingLabel.text = text
        self.activityViewFor.startAnimating()
    }
    
    //结束加载...
    func stopLoading(_ alertString: String = ""){
        if alertString != ""{
            self.removeAnimation()
            self.activityViewFor.stopAnimating()
            self.loadingLabel.text = alertString
            self.updateSnp()
        }
        self.dismiss()
    }
    
    //提示...
    func alert(_ text: String){
        self.removeAnimation()
        
        self.addToWindows()
        
        self.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.alpha = 1
        self.loadingLabel.text = text
        self.updateSnp()
        self.dismiss()
    }
    
    //消失动画
    func dismiss(){
        UIView.animate(withDuration: 0.35, delay: 1.5, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.alpha = 0
        }) { (f) -> Void in
            if f{
                self.activityViewFor.stopAnimating()
                self.removeFromSuperview()
            }
        }
    }
    
    func addToWindows(){
        self.frame = UIScreen.main.bounds
        if let window = UIApplication.shared.keyWindow{
            window.addSubview(self)
            return
        }
    }
    
}
