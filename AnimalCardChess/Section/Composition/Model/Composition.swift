//
//  Composition.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/16.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import Foundation

struct Composition {
    var id: String
    var startChesses: [Chess] //开局棋子布局数据。
    //开局...初始化方法
    init(id: String, startChesses: [Chess]){
        self.id = id
        self.startChesses = startChesses
    }

}

