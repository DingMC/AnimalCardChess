//
//  Chessboard.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/18.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import Foundation

struct Chessboard {
    let width: Int = 4
    let height: Int = 4
    
    //判断位置是否在棋盘内
    func isInBoard(by position: CBPosition)->Bool{
        return (0..<self.width).contains(position.x) && (0..<self.height).contains(position.y)
    }
    
}






