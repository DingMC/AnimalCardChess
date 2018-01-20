//
//  Chess.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/16.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import Foundation

struct Chess {
    
    var belong: Int //棋子的所属方 （0、1）
    var value: Int //棋子的值（1...8）
    var isShow: Bool = false  // 当前棋子是否翻开，默认没有翻开

    var position: CBPosition?
    
    var name: String{
        return Define.chessNames[value-1]
    }
    
    //初始化方法
    init(belong: Int, value: Int){
        self.belong = belong
        self.value = value
    }
    
    //判断是否可以吃子
    func canEat(_ chess: Chess)->Bool{
        //如果棋子还没有翻开，则不可吃。
        if !chess.isShow{
            return false
        }
        //如果是同一方棋子，则不可吃。
        if self.belong == chess.belong{
            return false
        }
        //如果当前棋子是8（鼠），则可以吃1（象）
        if self.value == 8 && chess.value == 1{
            return true
        }
        //如果当前棋子是1（象），则不可以吃8（鼠）
        if self.value == 1 && chess.value == 8{
            return false
        }
        //否则，当前棋子的值小于或等于的另一个棋子，则可以吃
        return  self.value <= chess.value
    }
    
}



