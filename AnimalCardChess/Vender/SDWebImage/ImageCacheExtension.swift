//
//  ImageCacheExtension.swift
//  AnimalCardChess
//
//  Created by masun on 2018/1/14.
//  Copyright © 2018年 dimgnc. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView{
    func mc_setImage(with url: URL!, placeholderImage placeholder: UIImage! = nil){
        self.sd_setImage(with: url, placeholderImage: placeholder)
    }
}
