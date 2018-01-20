//
//  UserManager.swift
//  AnimalCardChess
//
//  Created by masun on 2018/1/1.
//  Copyright © 2018年 dimgnc. All rights reserved.
//

import UIKit

enum LoginStatue{
    case unLogin //未登录
    case logining //正在登录中
    case logined //登录了
}

class UserManager: NSObject {
    
    //单例
    static let shared = UserManager()
    //当前用户
    var user: User?
    
    var loginStatus: LoginStatue = .unLogin
    
    //登录方法
    func login(_ account: String, password: String, completion: @escaping (_ errorMsg: String?)->()){
        
        let parameter: Parameter = ["account": account,
                                    "password": password]
        self.loginStatus = .logining
        NetworkUtil.shared.request(urlStr: APIDefine.User.login, parameter: parameter) { (response) in
            
            if let dict = response.parameter?["result"] as? Parameter{
                let data = dict.data()!
                do{
                    self.user = try JSONDecoder().decode(User.self, from: data)
                    self.loginStatus = .logined
                    self.connectSocket()
                    completion(nil)
                }catch{
                    self.loginStatus = .unLogin
                    completion("登录失败")
                }
            }else{
                self.loginStatus = .unLogin
                completion("登录失败")
            }
        }
    }
    
    func connectSocket(){
         MessageManager.shared.connect()
    }
    
    
    
    
}


