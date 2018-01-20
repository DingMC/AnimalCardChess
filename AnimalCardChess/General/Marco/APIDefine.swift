//
//  APIDefine.swift
//  AnimalCardChess
//
//  Created by masun on 2018/1/1.
//  Copyright © 2018年 dimgnc. All rights reserved.
//

import Foundation

struct APIDefine{
    
    //接口地址的根路径
//    static let BasePath = "http://192.168.2.172:8888/appapi"
//    static let BasePath = "http://anim.com.192.168.2.172.xip.io:8888/api"
    static let BasePath = "http://anim.com.192.168.1.132.xip.io:8888/api"
    
    struct Composition {
        //开始匹配
        /*
         * 用户id：uid
         */
        static let matching = "\(BasePath)/composition/matching"
        
        //走棋数据
        /*
         * step: Step
         */
        static let move = "\(BasePath)/composition/move"
        
        //悔棋请求
        /*
         * 用户id：uid
         */
        static let applyRegret = "\(BasePath)/composition/apply_regret"
        
        //是否同意悔棋
        /*
         * 用户id：uid
         * 是否同意：agree，  1：同意，2拒绝
         */
        static let regretResult = "\(BasePath)/composition/regret_result"
        
        //认输接口
        /*
         * 用户id：uid
         */
        static let giveUp = "\(BasePath)/composition/giveUp"
    }
    
    struct User {
        //登录接口
        static let login = "\(BasePath)/user/login"
        
        //绑定客户端id
        /*
         * 客户端id：client_id
         * 用户id：uid
         */
        static let bindclient = "\(BasePath)/user/bindclient"
    }
    
    
}
