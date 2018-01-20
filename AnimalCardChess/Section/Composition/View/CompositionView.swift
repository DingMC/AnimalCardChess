//
//  CompositionView.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/20.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

protocol CompositionViewDelegate: NSObjectProtocol{
    func clickChess(_ view: CompositionView, chess: Chess)
    func clickDirection(_ view: CompositionView, chess: Chess, direction: StepDirection)
}

//棋局...(棋盘+棋子)
class CompositionView: UIView{
    
    weak var delegate: CompositionViewDelegate?
    //棋盘
    var chessboard: ChessBoard!
    var chessButtons = [ChessButton?]()
    
    var wh: CGFloat = 0
    var padding: CGFloat  = 2.0
    
    //方向
    lazy var directionViews: DirectionViews = {
        let v = DirectionViews()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
        self.createSnp()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView(){
        //棋盘暂时用绿色背景代替图片
        self.chessboard = ChessBoard()
        self.chessboard.image = UIImage(named: "composition_bg_normal")
//        self.chessboard.backgroundColor = UIColor.green
        self.addSubview(self.chessboard)
        
    }
    
    func createSnp(){
        self.chessboard.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.wh = self.chessboard.frame.width/4
        self.directionViews.createWh(wh)
    }
    
    //加载棋局
    func loadChess(_ chesses: [Chess?]){
        //先移除原来的棋子
        for btn in self.chessButtons{
            btn?.removeFromSuperview()
        }
        self.chessButtons.removeAll()
        
        for chess in chesses{
            if chess == nil{
                self.chessButtons.append(nil)
                continue
            }
            let chessBtn = ChessButton(chess!)
            chessBtn.addTarget(self, action: #selector(self.didChess(_:)), for: .touchUpInside)
            self.chessButtons.append(chessBtn)
        }

        for (i, btn)in self.chessButtons.enumerated(){
            if btn == nil{
                continue
            }
            
            let x = CGFloat(i%4)*wh
            let y = CGFloat(i/4)*wh
            btn?.frame = CGRect(x: x+padding, y: y+padding, width: wh-padding*2, height: wh-padding*2)
            self.chessboard.addSubview(btn!)
        }
    }
    
    //走棋
    func move(_ step: Step, complish: @escaping ()->()){
        
        guard let curPosition = step.chess.position else {
            return
        }
        
        switch step.direction {
        case .turn:
            self.turn(curPosition, complish: complish)
            break
        case .right:
            self.curChessMove(curPosition: curPosition, newPosition: curPosition>+, complish: complish)
            break
        case .left:
            self.curChessMove(curPosition: curPosition, newPosition: curPosition>-, complish: complish)
            break
        case .up:
            self.curChessMove(curPosition: curPosition, newPosition: curPosition^+, complish: complish)
            break
        case .down:
            self.curChessMove(curPosition: curPosition, newPosition: curPosition^-, complish: complish)
            break
        }
    }
    
    //翻棋
    func turn(_ position: CBPosition, complish: @escaping ()->()){
        self.chessButtons[position.index]?.chess?.isShow = true
        self.chessButtons[position.index]?.turnChess(complish)
    }
    
    func curChessMove(curPosition: CBPosition, newPosition: CBPosition, complish: @escaping ()->()){
        
        guard let chessBtn = self.chessButtons[curPosition.index]  else {
            return
        }
        
        //走棋的动画
        UIView.animate(withDuration: 1.0, animations: {
            
            let x = CGFloat(newPosition.x)*self.wh
            let y = CGFloat(newPosition.y)*self.wh
            chessBtn.frame.origin = CGPoint(x: x+self.padding, y: y+self.padding)
            
            self.chessButtons[newPosition.index]?.removeFromSuperview()
        }) { (finish) in
            if finish{
                self.chessButtons[newPosition.index] = self.chessButtons[curPosition.index]
                self.chessButtons[newPosition.index]?.chess.position = newPosition
                self.chessButtons[curPosition.index] = nil
                complish()
            }
        }
    }
    
    @objc func didChess(_ chessBtn: ChessButton){
        self.directionViews.removeAll()
        self.delegate?.clickChess(self, chess: chessBtn.chess)
    }
    
    //显示方向按钮
    func showDirections(_ chess: Chess, directions: [StepDirection]){
        
        guard let curPosition = chess.position else{
            return
        }
        
         //右
        if directions.contains(.right){
            let rightPosition =  curPosition>+
            let x = CGFloat(rightPosition.x)*wh
            let y = CGFloat(rightPosition.y)*wh
            self.directionViews.directionRight.frame.origin = CGPoint(x: x, y: y)
            self.chessboard.addSubview(self.directionViews.directionRight)
        }else{
            self.directionViews.directionRight.removeFromSuperview()
        }

        //左
        if directions.contains(.left){
            let leftPosition =  curPosition>-
            let x = CGFloat(leftPosition.x)*wh
            let y = CGFloat(leftPosition.y)*wh
            self.directionViews.directionLeft.frame.origin = CGPoint(x: x, y: y)
            self.chessboard.addSubview(self.directionViews.directionLeft)
        }else{
            self.directionViews.directionLeft.removeFromSuperview()
        }
        
        //上
        if directions.contains(.up){
            let topPosition =  curPosition^+
            let x = CGFloat(topPosition.x)*wh
            let y = CGFloat(topPosition.y)*wh
            self.directionViews.directionTop.frame.origin = CGPoint(x: x, y: y)
            self.chessboard.addSubview(self.directionViews.directionTop)
        }else{
            self.directionViews.directionTop.removeFromSuperview()
        }
        
        //下
        if directions.contains(.down){
            let bottomPosition =  curPosition^-
            let x = CGFloat(bottomPosition.x)*wh
            let y = CGFloat(bottomPosition.y)*wh
            self.directionViews.directionBottom.frame.origin = CGPoint(x: x, y: y)
            self.chessboard.addSubview(self.directionViews.directionBottom)
        }else{
            self.directionViews.directionBottom.removeFromSuperview()
        }
        
        //闭包监听走棋方向按钮被点击。
        self.directionViews.didDirection { (direction) in
            self.delegate?.clickDirection(self, chess: chess, direction: direction)
        }
        
    }
    
    
}
