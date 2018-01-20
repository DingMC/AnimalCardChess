//
//  SetView.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/20.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class SetView: UIView {
    var backButton: UIButton!
    var regretButton: UIButton!
    var surrenderButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
        self.createSnp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(){
        self.backButton = UIButton()
        self.backButton.setTitle("返回", for: .normal)
        self.backButton.setTitleColor(Color.textH, for: .normal)
        self.addSubview(self.backButton)
        
        self.regretButton = UIButton()
        self.regretButton.setTitle("悔棋", for: .normal)
        self.regretButton.setTitleColor(Color.textH, for: .normal)
        self.addSubview(self.regretButton)
        
        self.surrenderButton = UIButton()
        self.surrenderButton.setTitle("认输", for: .normal)
        self.surrenderButton.setTitleColor(Color.textH, for: .normal)
        self.addSubview(self.surrenderButton)
        
    }
    
    func createSnp(){
        self.backButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(10)
        }
        
        self.regretButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.center.equalToSuperview()
        }
        
        self.surrenderButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(10)
        }
    }
}
