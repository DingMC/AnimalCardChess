//
//  HomeTableViewCell.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/18.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    var backView: UIView!
    var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if self.isHighlighted{
            self.backView.transform = self.backView.transform.scaledBy(x: 1.1, y: 1.1)
        }else{
            UIView.animate(withDuration: 0.5) { () -> Void in
                self.backView.transform = .identity
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        self.backView = UIView()
        self.backView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.backView)
        
        self.nameLabel = UILabel()
        self.nameLabel.textAlignment = .center
        self.nameLabel.textColor = Color.textH
        self.nameLabel.font = Font.middle
        self.backView.addSubview(self.nameLabel)
        self.createSnp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSnp(){
        self.backView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func update(_ object: HomeItem){
        self.nameLabel.text = object.name
    }

}
