//
//  ChessButton.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/20.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class ChessButton: UIButton {
    
    var chessImageView: UIImageView!
    var backImageView: UIImageView!
    var chessLabel: UILabel!
    
    var chess: Chess!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    
    convenience init(_ chess: Chess) {
        self.init(frame: CGRect.zero)
        self.chess = chess
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.chessImageView.frame = self.bounds
        self.backImageView.frame = self.bounds
        self.chessLabel.frame = self.bounds
    }

    func createView(){
        //先将背面视图加入
        self.backImageView = UIImageView()
        self.backImageView.backgroundColor = UIColor.black
//        self.addSubview(self.backImageView)
        
        self.chessImageView = UIImageView()
        
        self.chessLabel = UILabel()
        self.chessLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.chessLabel.textColor = UIColor.white
        self.chessLabel.textAlignment = .center
        
        self.chessImageView.addSubview(self.chessLabel)
        
        
    }
    
    func update() {
        self.chessLabel.text = self.chess.name
        self.chessLabel.backgroundColor = self.chess.belong == 0 ? UIColor.red : UIColor.blue
        
        if self.chess.isShow{
            self.addSubview(self.chessImageView)
        }else{
            self.addSubview(self.backImageView)
        }
        
    }
    
    //翻转...
    func turnChess(_ complish: @escaping ()->()){
        UIView.transition(from: self.backImageView, to: self.chessImageView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft) { (finished) in
            
            if finished{
                complish()
            }
        }
    }
    
}
