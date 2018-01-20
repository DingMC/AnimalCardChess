//
//  DirectionView.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/23.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class DirectionViews: NSObject {
    //走棋的方向按钮...
    lazy var directionLeft: DirectionButton = {
        let btn = DirectionButton()
        btn.direction = .left
        btn.addTarget(self, action: #selector(self.didDirctionButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var directionRight: DirectionButton = {
        let btn = DirectionButton()
        btn.direction = .right
        btn.addTarget(self, action: #selector(self.didDirctionButton(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var directionTop: DirectionButton = {
        let btn = DirectionButton()
        btn.direction = .up
        btn.addTarget(self, action: #selector(self.didDirctionButton(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var directionBottom: DirectionButton = {
        let btn = DirectionButton()
        btn.direction = .down
        btn.addTarget(self, action: #selector(self.didDirctionButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    var complish: ((_ direction: StepDirection)->())!
    
    @objc func didDirctionButton(_ btn: DirectionButton){
        self.removeAll()
        self.complish?(btn.direction)
    }
    
    func removeAll(){
        self.directionLeft.removeFromSuperview()
        self.directionRight.removeFromSuperview()
        self.directionTop.removeFromSuperview()
        self.directionBottom.removeFromSuperview()
    }
    
    func createWh(_ wh: CGFloat){
        let bounds = CGRect(x: 0, y: 0, width: wh, height: wh)
        self.directionLeft.bounds = bounds
        self.directionRight.bounds = bounds
        self.directionTop.bounds = bounds
        self.directionBottom.bounds = bounds
    }
    
    func didDirection(_ complish: @escaping (_ direction: StepDirection)->()){
        self.complish = complish
    }
}
