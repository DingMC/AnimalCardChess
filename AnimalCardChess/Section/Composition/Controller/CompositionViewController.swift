//
//  CompositionViewController.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/16.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

class CompositionViewController: BaseViewController {

    var type: Int = 0 //0:双人，1:人机, 2:联网
    var compositionManager =  CompositionManager.shared
    
    lazy var playerOneView: PlayerView = {
        let v = PlayerView()
        v.snpRight()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var playerTwoView: PlayerView = {
        let v = PlayerView()
        v.snpLeft()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var setView: SetView = {
        let v = SetView()
        v.backgroundColor = UIColor.white
        return v
    }()
    lazy var compositionView: CompositionView = {
        let v = CompositionView()
        v.delegate = self
        v.backgroundColor = UIColor.white
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createView()
        self.createSnp()
        self.createGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reload()
    }
    
    func createView(){
        self.view.addSubview(playerOneView)
        self.view.addSubview(playerTwoView)
        self.view.addSubview(setView)
        self.view.addSubview(compositionView)
        
        self.setView.backButton.addTarget(self, action: #selector(self.didBackButton), for: .touchUpInside)
        self.setView.regretButton.addTarget(self, action: #selector(self.didRegretButton), for: .touchUpInside)
        self.setView.surrenderButton.addTarget(self, action: #selector(self.didSurrenderButton), for: .touchUpInside)
    }
    
    func createSnp(){
        self.playerTwoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        self.playerOneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.compositionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        self.compositionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.playerTwoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(self.compositionView.snp.width)
        }
        
        self.setView.snp.makeConstraints { (make) in
            make.top.equalTo(self.playerOneView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func createGame(){
        self.compositionManager.delegate = self
    }
    
    //开始游戏
    func reload(){
        self.compositionManager.beginGame()
    }
    
    //返回
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //新游戏
    func newGame(){
        let composition = Composition(id: "1", startChesses: CompositionUtil.randomQue())
        CompositionManager.shared.compositionCreate(composition: composition)
        self.reload()
    }
    
    //set...
    @objc func didBackButton(){
        let alertView = UIAlertController(title: "确认返回", message: "返回后游戏就结束了", preferredStyle: .alert)
        let actionSure = UIAlertAction(title: "确定", style: .default) { (action) in
            self.back()
        }
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertView.addAction(actionSure)
        alertView.addAction(actionCancel)
        self.present(alertView, animated: true, completion: nil)
    }
    @objc func didRegretButton(){
        if self.compositionManager.canRegret{
            let alertView = UIAlertController(title: "提示", message: "确认要悔棋", preferredStyle: .alert)
            let actionSure = UIAlertAction(title: "确定", style: .default) { (action) in
                self.compositionManager.applyRegret()
            }
            let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertView.addAction(actionSure)
            alertView.addAction(actionCancel)
            self.present(alertView, animated: true, completion: nil)
        }else{
            let alertView = UIAlertController(title: "提示", message: "此时不支持悔棋", preferredStyle: .alert)
            let actionSure = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertView.addAction(actionSure)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    @objc func didSurrenderButton(){
        let alertView = UIAlertController(title: "提示", message: "确认认输", preferredStyle: .alert)
        let actionNext = UIAlertAction(title: "重新游戏", style: .default) { (action) in
            if self.compositionManager.type == .online{
                self.compositionManager.giveUp()
            }
            self.newGame()
        }
        let actionOut = UIAlertAction(title: "退出游戏", style: .default) { (action) in
            self.back()
        }
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertView.addAction(actionNext)
        alertView.addAction(actionOut)
        alertView.addAction(actionCancel)
        self.present(alertView, animated: true, completion: nil)
    }
    
}

extension CompositionViewController: CompositionViewDelegate{
    //界面棋子被点击了，告诉manager，处理相关逻辑
    func clickChess(_ view: CompositionView, chess: Chess) {
        self.compositionManager.clickedChess(chess)
    }
    
    //棋子要走的方向按钮被点击了，告诉manager，处理相关逻辑
    func clickDirection(_ view: CompositionView, chess: Chess, direction: StepDirection) {
        self.compositionManager.move(chess, direction: direction)
    }
}

extension CompositionViewController: CompositionManagerDelegate{
    //游戏开始..初始化设置相关信息
    func gameBegin(_ manager: CompositionManager) {
        self.playerOneView.player = manager.playerOne
        self.playerTwoView.player = manager.playerTwo
        
        self.compositionView.loadChess(manager.composition.startChesses)
        self.playerSwitched(manager)
    }
    
    func didMove(_ manager: CompositionManager, step: Step) {
        //开始走棋动画...
        self.compositionView.move(step) {
            manager.chessMoved()
        }
    }
    
    func gameOver(_ manager: CompositionManager) {
        let curName = manager.curPlayer.name
        var title =  "游戏结束"
        var message = "\(curName)获胜啦"
        if manager.type == .online{
            if manager.curPlayer.id == manager.playerOne.id{
                //自己获胜
                title = "胜"
                message = "您获胜了"
            }else{
                title = "败"
                message = "您失败了"
            }
        }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionNext = UIAlertAction(title: "下一局", style: .default) { (action) in
            self.newGame()
        }
        let actionBack = UIAlertAction(title: "返回", style: .default) { (action) in
            self.back()
        }
        alertView.addAction(actionNext)
        alertView.addAction(actionBack)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showDirections(_ manager: CompositionManager, chess: Chess, directions: [StepDirection]) {
        self.compositionView.showDirections(chess, directions: directions)
    }
    
    func playerSwitched(_ manager: CompositionManager){
        if manager.curPlayer.id == manager.playerOne.id{
            self.playerOneView.isMoving = true
            self.playerTwoView.isMoving = false
        }else{
            self.playerOneView.isMoving = false
            self.playerTwoView.isMoving = true
        }
        
        if manager.type == .ai {
            if manager.curPlayer.isAI{
                self.compositionView.isUserInteractionEnabled = false
            }else{
                self.compositionView.isUserInteractionEnabled = true
            }
        }
        if manager.type == .online {
            if manager.curPlayer.id == manager.playerTwo.id{
                self.compositionView.isUserInteractionEnabled = false
            }else{
                self.compositionView.isUserInteractionEnabled = true
            }
        }
    }
    
    func didRegret(_ manager: CompositionManager){
        self.compositionView.loadChess(manager.curChesses)
    }
    
    //申请了悔棋
    func applyRegret(_ manager: CompositionManager){
        let alertView = UIAlertController(title: "提示", message: "对方申请悔棋，是否同意", preferredStyle: .alert)
        let actionAgree = UIAlertAction(title: "同意", style: .default) { (action) in
            self.compositionManager.agreeRegret(1)
        }
        let actionRefuse = UIAlertAction(title: "拒绝", style: .default) { (action) in
            self.compositionManager.agreeRegret(0)
        }
        alertView.addAction(actionAgree)
        alertView.addAction(actionRefuse)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    //悔棋结果
    func resultRegret(_ manager: CompositionManager, agree: Bool){
        if agree{
            self.compositionManager.regret()
        }else{
            let alertView = UIAlertController(title: "提示", message: "对方不同意悔棋", preferredStyle: .alert)
            let actionSure = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertView.addAction(actionSure)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func giveUp(_ manager: CompositionManager) {
        let alertView = UIAlertController(title: "提示", message: "游戏结束，对方认输", preferredStyle: .alert)
        let actionSure = UIAlertAction(title: "确定",  style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(actionSure)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    
}
