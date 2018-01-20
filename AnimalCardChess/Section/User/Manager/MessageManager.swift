//
//  MessageManager.swift
//  AnimalCardChess
//
//  Created by masun on 2018/1/1.
//  Copyright © 2018年 dimgnc. All rights reserved.
//

import UIKit
import Starscream

protocol StepProtocol: NSObjectProtocol {
    func didStep(_ dict: [String: Any])
    //对方申请悔棋
    func applyRegret(_ messageManager: MessageManager)
    //对方处理悔棋申请结果
    func resultRegret(_ messageManager: MessageManager, agree: Bool)
    
    //对方认输
    func giveUp(_ messageManager: MessageManager)
}


protocol MatchingProtocol: NSObjectProtocol {
    func matchingSucceed(_ dict: [String: Any])
}

class MessageManager: NSObject{
    weak var matchingDelegate: MatchingProtocol?
    weak var stepDelegate: StepProtocol?
    
    static let shared = MessageManager()
    
    var socket: WebSocket!
    
    var client_id: String!
    override init() {
        super.init()
//        self.socket = WebSocket(url: URL(string: "ws://192.168.2.172:8384/")!)
        self.socket = WebSocket(url: URL(string: "ws://192.168.1.132:8384/")!)
        self.socket.delegate = self
    }
    
    func connect(){
        self.socket?.connect()
    }
    
    //处理消息数据
    func handleResponse(_ result: [String: Any]){
        guard let type = result["type"] as? String else{
            return
        }
        
        if type == "init"{
            self.client_id = result["client_id"] as? String
            self.bindClient()
            return
        }
        
        guard let messageDict = result["message"] as? [String: Any]  else{
            return
        }
        //匹配成功
        if type == "matched"{
            self.matchingDelegate?.matchingSucceed(messageDict)
            return
        }
        
        //走棋数据
        if type == "step"{
            self.stepDelegate?.didStep(messageDict)
            return
        }
        
        //申请悔棋
        if type == "applyRegret"{
            self.stepDelegate?.applyRegret(self)
            return
        }
        
        //同意悔棋
        if type == "agreeRegret"{
            self.stepDelegate?.resultRegret(self, agree: true)
            return
        }
        
        //拒绝悔棋
        if type == "refuseRegret"{
            self.stepDelegate?.resultRegret(self, agree: false)
            return
        }
        
        //认输
        if type == "giveUp"{
            self.stepDelegate?.giveUp(self)
            return
        }
        
        
    }
    
    func bindClient(){
        guard let user = UserManager.shared.user else{
            return
        }
        
        if self.client_id == nil {
            self.connect()
            return
        }
        
        let parameter: Parameter = [
            "client_id"   : self.client_id!,
             "uid"   : user.id,
            ]
        
        NetworkUtil.shared.request(urlStr: APIDefine.User.bindclient, parameter: parameter) { (response) in
            guard let flag = response.parameter?["flag"] as? Int else{
                print("绑定失败")
                return
            }
            if flag == 1{
                print("绑定成功")
            }else{
                print("绑定失败")
            }
        }
    }
    
    
    
}

extension MessageManager: WebSocketDelegate{
    func websocketDidConnect(socket: WebSocketClient) {
        print("连接成功")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("断开连接")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("收到消息: ", text)
        let data = text.data(using: String.Encoding.utf8)
        if let dict = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]{
            print("reslut: ", dict)
            self.handleResponse(dict)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
       
    }
}

