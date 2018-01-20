//
//  CBPosition.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/22.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import Foundation

struct CBPosition{
    var x: Int
    var y: Int
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
    
    init(index: Int){
        self.x = index%4
        self.y = index/4
    }
    
    var index: Int{
        return self.y*4 + self.x
    }
    
    //判断位置是否在棋盘内
    var isInBoard: Bool{
        return (0..<4).contains(self.x) && (0..<4).contains(self.y)
    }
}

extension CBPosition: Moveable{
    
    //右移，相当于x坐标加1
    static postfix func >+(left: CBPosition) -> CBPosition {
        return CBPosition(x: left.x+1, y: left.y)
    }
    
    //左移，相当于x坐标减1
    static postfix func >-(left: CBPosition) -> CBPosition {
        return CBPosition(x: left.x-1, y: left.y)
    }
    
    //上移，相当于y坐标减1（坐标系y轴方向朝下）
    static postfix func ^+(left: CBPosition) -> CBPosition {
        return CBPosition(x: left.x, y: left.y-1)
    }
    
    //下移，相当于y坐标加1（坐标系y轴方向朝下）
    static postfix func ^-(left: CBPosition) -> CBPosition {
        return CBPosition(x: left.x, y: left.y+1)
    }
}

