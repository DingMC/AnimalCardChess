//
//  Player.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/16.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import Foundation

struct Player: Codable {
    var id: String //玩家id
    var name: String //玩家名称
    var avatar: String //玩家头像
    
    //代表AI玩家...
    var isAI: Bool = false
    
    init(id: String, name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
}







