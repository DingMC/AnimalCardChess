//
//  CompositionUtil.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/22.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class CompositionUtil: NSObject {
    //创建所有棋子
    class func createChess()->[Chess]{
        var chesses = [Chess]()
        for i in 1...8{
            let chess0 = Chess(belong: 0, value: i)
            chesses.append(chess0)
            let chess1 = Chess(belong: 1, value: i)
            chesses.append(chess1)
        }
        return chesses
    }
    
    //生成随机的棋局...
    class func randomQue()->[Chess]{
        var positionArr = [Chess]()
        var ranArr = CompositionUtil.createChess()
        
        let N = ranArr.count
        for i in 0..<N{
            let index: Int = Int(arc4random() % UInt32(ranArr.count))
            //棋子的位置...
            ranArr[index].position = CBPosition(index: i)
            positionArr.append(ranArr[index])
            ranArr.remove(at: index)
        }
        return positionArr
    }
    
    //根据Int数组生成棋局...
    class func createQue(_ bvs: [Int])->[Chess]{
        let positionArr = bvs.enumerated().map({ (bv, i) -> Chess in
            var chess = Chess(belong: bv/10, value: bv%10)
            chess.position = CBPosition(index: i)
            return chess
        })
        return positionArr
    }
}
