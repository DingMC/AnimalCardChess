//
//  AIManager.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/30.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class AIManager: NSObject {
    
    var history = Dictionary<String, Move>()
    
    var curManager: CompositionManager!
    
    
    
    func curKey(_ chesses: [Chess?])->String{
        var key = ""
        for chess in chesses{
            if chess == nil{
                key += "xx"
            }else{
                key += "\(chess!.belong)\(chess!.value)"
            }
        }
        return key
    }
    
    //思考深度。
    var treeDepth = 5
    
    func think(_ manager: CompositionManager, complish: @escaping (_ move: Move)->()){
        self.curManager = manager
        let depth = self.treeDepth
        let curValue = -9999//一开始定义自己的局面值很低，这样就可以获得是自己损失最小的走法
        DispatchQueue.main.async {
            let move = self.think(alpha: curValue, beta: -curValue, depth: depth, move: nil)
            complish(move)
        }
    }
    
    //思考算法
    func think(alpha: Int, beta: Int, depth: Int, move: Move!)->Move{
        //深度为0了就不再思考了，直接返回当前局面值
        if depth == 0{
            return Move(value: self.evaluate(), step: move.step)
        }
        //搜索所有走法
        let steps = self.searchAllSteps()
        //过滤翻棋
        let moveSteps = steps.filter { (step) -> Bool in
            return step.direction != .turn
        }
        
        //记录最佳走法
        var niceStep: Step!
        var myAlpha = alpha
        
        //遍历所有走法
        for step in moveSteps{
            //走这个走法
            self.curManager.move(step)
            //走完这步获胜则直接返，不需要再继续思考对方的走棋过程...
            if self.curManager.judgeGameOver(){
                //撤消这步走棋（只是思考过程，所以走棋需要撤销）
                self.curManager.switchPlayer()
                self.curManager.regret()
                //游戏结束...
                return Move(value: 8888, step: step)
            }
            self.curManager.switchPlayer()
            //走棋后记录当前的局面值..
            let nextMove = Move(value: self.evaluate(), step: step)
            //思考对手走棋...(思考过程递归调用...)
            let otherMove = self.think(alpha: -beta, beta: -myAlpha, depth: depth-1, move: nextMove)
            
            let otherVal = -otherMove.value
            
            //撤消这步走棋，（思考过对方的走棋情况再撤销）
            self.curManager.regret()
            
            if otherVal >= beta{
                //截断
                return nextMove
            }
            if otherVal > myAlpha{
                niceStep = step
                myAlpha = otherVal
            }
        }
        
        if niceStep != nil{
            if myAlpha != alpha{
                return Move(value: myAlpha, step: niceStep)
            }
        }
        
        //如果不是根节点.....
        if self.treeDepth > depth{
            return Move(value: self.evaluate(), step: move.step)
        }
        
        //没有最佳根节点的走法...说明怎么走都得不到有利的局面，那么就随机返回一个走法，（增加随机性，使得思考更加人性化）
        let ranInt = Int(arc4random() % UInt32(steps.count))
        return Move(value: myAlpha, step: steps[ranInt])
    }
    
    func searchAllSteps()->[Step]{
        var steps = [Step]()
        for chess in self.curManager.curChesses{
            //
            if chess == nil{
                continue
            }
            
            //棋子未翻开记录棋可翻
            if !chess!.isShow{
                let step = Step(count: self.curManager.stepArr.count+1, playerId: self.curManager.curPlayer.id, chess: chess!, direction: .turn)
                steps.append(step)
                continue
            }
            
            //不是自己的棋子不可以走
            if !self.curManager.chessIsCur(chess!){
                continue
            }
            
            //获取当前棋子所有可以走的方向，循环加入走法记录里
            let directions = self.curManager.moveDirections(chess!)
            if directions.count == 0{
                continue
            }
            for direction in directions{
                self.curManager.move(chess!, direction: direction)
                let step = self.curManager.stepArr.last!
                steps.append(step)
                self.curManager.switchPlayer()
                self.curManager.regret()
            }
        }
        return steps
    }
    
    
    //局面评估函数
    func evaluate()->Int{
        var eValue = 0
        for chess in self.curManager.curChesses{
            if chess == nil{
                continue
            }
            if self.curManager.chessIsCur(chess!){
                eValue += self.chessPrice(chess!)
            }else{
                eValue -= self.chessPrice(chess!)
            }
        }
        return eValue
    }
    
    //当前棋局下棋子的价值...不同棋子的价值不同，不同情况下的相同棋子价值也不同
    //定义价值如下: 象10、狮8、虎6、豹5、狼4、狗3、猫2.
    //若对方象还在：（我方象不在鼠9）（我方象还在鼠7），
    //若对方象不在：鼠1，
    func chessPrice(_ chess: Chess)->Int{
        switch chess.value {
        case 1:
            return 10
        case 2:
            return 8
        case 3:
            return 6
        case 4:
            return 5
        case 5:
            return 4
        case 6:
            return 3
        case 7:
            return 2
        case 8://鼠
            //自己的象是否存在
            var myElephanExist = false
            //对方的象是否存在
            var otherElephanExist = false
            
            for chess in self.curManager.curChesses{
                if chess == nil{
                    continue
                }
                if chess!.value != 1{
                    continue
                }
                if self.curManager.chessIsCur(chess!){
                    myElephanExist = true
                }else{
                    otherElephanExist = true
                }
            }
            //如果对方的象存在
            if otherElephanExist{
                //我的象也存在返回7，我的象不存在更加重要，返回9
                if myElephanExist{
                    return 7
                }else{
                    return 9
                }
            }else{
                return 1
            }
        default:
            return 0
        }
    }
}
