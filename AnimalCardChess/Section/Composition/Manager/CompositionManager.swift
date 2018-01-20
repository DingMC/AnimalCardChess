//
//  CompositionManager.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/22.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

//棋局类型
enum CompositionType {
    case outline
    case ai
    case online
}

protocol CompositionManagerDelegate: NSObjectProtocol {
    //游戏开始
    func gameBegin(_ manager: CompositionManager)
    //走棋
    func didMove(_ manager: CompositionManager, step: Step)
    //游戏结束
    func gameOver(_ manager: CompositionManager)
    //选择方向
    func showDirections(_ manager: CompositionManager, chess: Chess, directions: [StepDirection])
    //改变玩家了
    func playerSwitched(_ manager: CompositionManager)
    //执行了悔棋
    func didRegret(_ manager: CompositionManager)
    
    //申请了悔棋
    func applyRegret(_ manager: CompositionManager)
    
    //悔棋结果
    func resultRegret(_ manager: CompositionManager, agree: Bool)
    
    //认输
    func giveUp(_ manager: CompositionManager)
}

class CompositionManager: NSObject {
    
    //单例
    static let shared = CompositionManager()
    
    weak var delegate: CompositionManagerDelegate?

    var composition: Composition!
    
    var playerOne: Player! //玩家一
    var playerTwo: Player! //玩家二
    
    var stepArr = [Step]()//走棋记录的数组。
    
    var curChesses = [Chess?]()//游戏中记录当前的棋盘上的棋子情况
    
    var curPlayer: Player!//游戏中记录当前走棋的玩家

    var type: CompositionType = .outline{
        didSet{
            if type == .online{
                MessageManager.shared.stepDelegate = self
            }
        }
    }
    
    //当前是否可以悔棋
    var canRegret: Bool{
        guard let step = self.stepArr.last else{
            return false
        }
        return step.direction != .turn
    }
    
    //玩家加入
    func playerJoin(playerOne: Player, playerTwo: Player){
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        //设置当前走棋的玩家
        self.curPlayer = self.playerOne
    }
    
    //棋局创建
    func compositionCreate(composition: Composition){
        self.composition = composition
        self.curChesses = composition.startChesses
    }
    
    //游戏开始
    func beginGame(){
        self.delegate?.gameBegin(self)
    }
    
    //棋子被点击了
    func clickedChess(_ chess: Chess){
        if chess.isShow{
            //不是当前玩家的棋子不可操作
            if !self.chessIsCur(chess){
                return
            }
            //计算当前棋子有哪些可以走的方向
            let directions = self.moveDirections(chess)
            self.delegate?.showDirections(self, chess: chess, directions: directions)
        }else{
            self.move(chess, direction: .turn)
        }
    }
    
    //判断棋子是否是当前玩家可操作的...
    func chessIsCur(_ chess: Chess)->Bool{
        if self.stepArr.count == 0{
            return true
        }
        //获取第一步..第一步是决定玩家拥有哪一方棋子的。
        let step = self.stepArr[0]
        if self.curPlayer.id == step.playerId{
            return chess.belong == step.chess.belong
        }else{
            return chess.belong != step.chess.belong
        }
    }
    
    
    
    //当前棋子可以移动的所有方向
    func moveDirections(_ chess: Chess)->[StepDirection]{
        var directions = [StepDirection]()
        guard let curPosition = chess.position else {
            return directions
        }
        if !chess.isShow{
            return [.turn]
        }
        //右
        let rightPosition = curPosition>+
        if self.judgeCanMove(chess, newPosition: rightPosition){
            directions.append(.right)
        }
        //左
        let leftPosition = curPosition>-
        if self.judgeCanMove(chess, newPosition: leftPosition){
            directions.append(.left)
        }
        //上
        let topPosition = curPosition^+
        if self.judgeCanMove(chess, newPosition: topPosition){
            directions.append(.up)
        }
        //下
        let bottomPosition = curPosition^-
        if self.judgeCanMove(chess, newPosition: bottomPosition){
            directions.append(.down)
        }
        return directions
    }
    
    func judgeCanMove(_ chess: Chess, newPosition: CBPosition)->Bool{
        //目标位置不在棋盘内返回false
        if !newPosition.isInBoard{
            return false
        }
        //目标位置是否有棋子，没有返回true，有则判断是否可以吃
        if let toChess = self.curChesses[newPosition.index]{
            return chess.canEat(toChess)
        }
        return true
    }
    
    //根据走棋数据走棋
    func move(_ step: Step){
        self.move(step.chess, direction: step.direction)
    }
    
    //开始走棋逻辑
    func move(_ chess: Chess, direction: StepDirection){
        var step = Step(count: self.stepArr.count+1, playerId: self.curPlayer.id, chess: chess, direction: direction)
        guard let curPosition = chess.position else {
            return
        }
        
        var beEat: Chess?
        switch direction {
        case .turn:
            self.curChesses[curPosition.index]?.isShow = true
            break
        case .right:
            beEat = self.curChessMove(curPosition: curPosition, newPosition: curPosition>+)
            break
        case .left:
            beEat = self.curChessMove(curPosition: curPosition, newPosition: curPosition>-)
            break
        case .up:
            beEat = self.curChessMove(curPosition: curPosition, newPosition: curPosition^+)
            break
        case .down:
            beEat = self.curChessMove(curPosition: curPosition, newPosition: curPosition^-)
            break
        }
        step.beEat = beEat
        self.stepArr.append(step)
        //走棋逻辑结束后，通知界面
        self.delegate?.didMove(self, step: step)
        
        //当前是联网对战，将自己的走棋数据传给对方
        if self.type == .online{
            if self.curPlayer.id == self.playerOne.id{
                self.uploadStep(step)
            }
        }
        
    }
    
    //走棋后棋子位置改变，改变当前棋盘的数组并返回被吃的棋子
    func curChessMove(curPosition: CBPosition, newPosition: CBPosition)->Chess?{
        let beEat = self.curChesses[newPosition.index]
        self.curChesses[newPosition.index] = self.curChesses[curPosition.index]
        self.curChesses[newPosition.index]?.position = newPosition
        self.curChesses[curPosition.index] = nil
        return beEat
    }
    
    //走棋动画完成
    func chessMoved(){
        if self.judgeGameOver(){
            self.delegate?.gameOver(self)
        }else{
            self.switchPlayer()
            if self.curPlayer.isAI{
                let manager = CompositionManager()
                manager.composition = self.composition
                manager.playerOne = self.playerOne
                manager.playerTwo = self.playerTwo
                manager.stepArr = self.stepArr
                manager.curChesses = self.curChesses
                manager.curPlayer = self.curPlayer
                
                let ai = AIManager()
                ai.think(manager, complish: { (move) in
                    self.move(move.step)
                })
            }
        }
    }
    
    //判断游戏是否结束...
    func judgeGameOver()->Bool{
        var count1:Int = 0
        var count2:Int = 0
        
        for chess in self.curChesses{
            
            //如果棋子不存在直接进入下个循环
            if chess == nil{
                continue
            }
            
            //如果棋子翻开了，但是没有方向可走进入下个循环
            if chess!.isShow && self.moveDirections(chess!).count == 0{
                continue
            }
            
            //分别记录不同方的当前可走棋子数量情况
            if chess!.belong == 0{
                count1 += 1
            }else{
                count2 += 1
            }
        }
        //只要有一方当前可走棋子数量为0 就代表游戏结束
        return count1 == 0 || count2 == 0
    }
    
    //改变当前玩家...
    func switchPlayer(){
        if self.curPlayer.id == self.playerOne.id{
            self.curPlayer = self.playerTwo
        }else{
            self.curPlayer = self.playerOne
        }
        self.delegate?.playerSwitched(self)
    }
    
    //申请悔棋
    func applyRegret(){
        //如果不是联网匹配直接执行悔棋功能。
        if self.type != .online{
            self.regret()
            return
        }
        
        let parameter: Parameter = ["uid": ""]
        
        NetworkUtil.shared.request(urlStr: APIDefine.Composition.applyRegret, parameter: parameter) { (response) in
            
        }
    }
    
    
    
    //是否同意悔棋
    func agreeRegret(_ agree: Int){
        let parameter: Parameter = ["uid": "",
                                    "agree": agree]
        
        NetworkUtil.shared.request(urlStr: APIDefine.Composition.applyRegret, parameter: parameter) { (response) in
            
        }
        
    }
    
    //发送认输
    func giveUp(){
        let parameter: Parameter = ["uid": ""]
        
        NetworkUtil.shared.request(urlStr: APIDefine.Composition.giveUp, parameter: parameter) { (response) in
            
        }
        
    }
    
    //悔棋
    func regret(){
        //首先获取走棋记录最后一条数据
        guard let step = self.stepArr.last else{
            return
        }
        
        let curPosition = step.chess.position!
        self.curChesses[curPosition.index] = step.chess
        switch step.direction {
        case .turn:
            break
        case .right:
            self.curChesses[curPosition>+.index] = step.beEat
            break
        case .left:
            self.curChesses[curPosition>-.index] = step.beEat
            break
        case .up:
            self.curChesses[curPosition^+.index] = step.beEat
            break
        case .down:
            self.curChesses[curPosition^-.index] = step.beEat
            break
        }
        self.delegate?.didRegret(self)
        self.stepArr.remove(at: self.stepArr.count-1)
        //悔棋后也是要交换当前玩家的
        self.switchPlayer()
    }
    
    //上传走棋数据
    func uploadStep(_ step: Step){
        let parameter: Parameter = ["uid": ""]
        
        NetworkUtil.shared.request(urlStr: APIDefine.Composition.move, parameter: parameter) { (response) in

        }
    }
    
    
}

extension CompositionManager: StepProtocol{
    func didStep(_ dict: [String: Any]){
        let step = Step(count: 0, playerId: "", chess: Chess(belong: 1, value: 2), direction: .down )
        self.move(step)
    }
    
    //对方申请悔棋
    func applyRegret(_ messageManager: MessageManager){
        self.delegate?.applyRegret(self)
    }
    //对方悔棋处理结果
    func resultRegret(_ messageManager: MessageManager, agree: Bool){
        self.delegate?.resultRegret(self, agree: agree)
    }
    
    func giveUp(_ messageManager: MessageManager) {
        self.delegate?.giveUp(self)
    }
    
}


