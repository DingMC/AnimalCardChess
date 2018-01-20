//
//  Extension+UIColor.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/20.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

extension UIColor{
    //16进制表示颜色值方法
    /**
     * code: 16进制字符串
     */
    convenience init(_ code: String) {
        //首先定义一个16进制转化成系统自带颜色值的方法。
        let colorComponent = {(start : Int ,length : Int) -> CGFloat in
            
            let i = code.index(code.startIndex, offsetBy: start)
            let j = code.index(code.startIndex, offsetBy: start+length)
            
            //这里subHex的类型是Substring
            let subHex = code[i..<j]
            
            //如果只有一位数，则代表是重复的两位简写
            let subHexStr = length < 2 ? "\(subHex)\(subHex)" : String(subHex)

            //16进制转10进制
            var component:UInt32 = 0
            Scanner(string: subHexStr).scanHexInt32(&component)
            return CGFloat(component) / 255.0
        }
        
        //区分字符串的长度判断当前颜色值的格式
        let argb = {() -> (CGFloat,CGFloat,CGFloat,CGFloat) in
            switch(code.count) {
            case 3: //#RGB
                let red = colorComponent(0,1)
                let green = colorComponent(1,1)
                let blue = colorComponent(2,1)
                return (red,green,blue,1.0)
            case 4: //#ARGB
                let alpha = colorComponent(0,1)
                let red = colorComponent(1,1)
                let green = colorComponent(2,1)
                let blue = colorComponent(3,1)
                return (red,green,blue,alpha)
            case 6: //#RRGGBB
                let red = colorComponent(0,2)
                let green = colorComponent(2,2)
                let blue = colorComponent(4,2)
                return (red,green,blue,1.0)
            case 8: //#AARRGGBB
                let alpha = colorComponent(0,2)
                let red = colorComponent(2,2)
                let green = colorComponent(4,2)
                let blue = colorComponent(6,2)
                return (red,green,blue,alpha)
            default:
                return (1.0,1.0,1.0,1.0)
            }}
        
        let color = argb()
        self.init(red: color.0, green: color.1, blue: color.2, alpha: color.3)
    }
}
