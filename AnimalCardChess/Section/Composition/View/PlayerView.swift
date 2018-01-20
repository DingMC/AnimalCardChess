//
//  PlayerView.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/20.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    var avatarImageView: UIImageView!
    var nameLabel: UILabel!
    
    var curMoveLabel: UILabel!
    
    var player: Player!{
        didSet{
            self.update()
        }
    }
    
    var isMoving: Bool = false{
        didSet{
            self.curMoveLabel?.isHidden = !isMoving
        }
    }
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(){
        self.avatarImageView = UIImageView()
        self.avatarImageView.backgroundColor = Color.mainBg
        self.addSubview(self.avatarImageView)
        
        self.nameLabel = UILabel()
        self.nameLabel.textColor = Color.textH
        self.nameLabel.font = Font.middle
        self.nameLabel.text = "玩家昵称"
        self.addSubview(self.nameLabel)
        
        self.curMoveLabel = UILabel()
        self.curMoveLabel.textColor = Color.textL
        self.curMoveLabel.font = Font.middle
        self.curMoveLabel.text = "思考中..."
        self.curMoveLabel.isHidden = true
        self.addSubview(self.curMoveLabel)
        
    }
    
    func update(){
        self.nameLabel.text = self.player?.name
        if CompositionManager.shared.type == .online{
             self.avatarImageView.mc_setImage(with: URL(string: self.player!.avatar))
        }else{
            self.avatarImageView.image = UIImage(named: self.player!.avatar)
        }
    }
    
    //头像在左边的约束
    func snpLeft(){
        self.avatarImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(10)
            make.height.equalTo(self.avatarImageView.snp.width)
        }
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.top.equalTo(self.avatarImageView)
        }

        self.curMoveLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.bottom.equalTo(self.avatarImageView)
        }
    }
    
    //头像在右边的约束
    func snpRight(){
        self.avatarImageView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview().inset(10)
            make.height.equalTo(self.avatarImageView.snp.width)
        }
        self.nameLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.avatarImageView.snp.left).offset(-10)
            make.top.equalTo(self.avatarImageView)
        }
        
        self.curMoveLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.avatarImageView.snp.left).offset(-10)
            make.bottom.equalTo(self.avatarImageView)
        }
    }
    
    
}
