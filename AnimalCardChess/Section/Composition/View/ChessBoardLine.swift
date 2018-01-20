//
//  ChessBoardLine.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/21.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class ChessBoardLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var lineColor: UIColor = UIColor.white{
        didSet{
            self.setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //划分割线...
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(1)
        
        //循环加入3条横向分割线
        for i in 0..<3{
            let y = CGFloat(i+1) * rect.height/4
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: rect.width, y: y))
            context.strokePath()
        }
        //循环加入3条纵向分割线
        for i in 0..<3{
            let x = CGFloat(i+1) * rect.width/4
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: rect.height))
            context.strokePath()
        }
    }
}
