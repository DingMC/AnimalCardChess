//
//  Extension+Dictionary.swift
//  AnimalCardChess
//
//  Created by masun on 2018/1/1.
//  Copyright © 2018年 dimgnc. All rights reserved.
//

import Foundation

extension Dictionary{
    func data()->Data?{
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return data
    }
}
