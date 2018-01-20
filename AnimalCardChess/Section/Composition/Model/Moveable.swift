//
//  Moveable.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/22.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import Foundation

postfix operator >+ //右移
postfix operator >- //左移
postfix operator ^+ //下移
postfix operator ^- //上移

protocol Moveable{
    static postfix func >+ (left: Self) -> Self
    static postfix func >- (left: Self) -> Self
    static postfix func ^+ (left: Self) -> Self
    static postfix func ^- (left: Self) -> Self
}
