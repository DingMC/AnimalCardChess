//
//  NetworkUtil.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/31.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit

enum NetMethod: String{
    case GET = "GET"
    case POST = "POST"
}

typealias Parameter = [String: Any]

class NetworkUtil: NSObject {
    //单例
    static let shared = NetworkUtil()
    
    var timeoutInterval: TimeInterval = 15.0
    
    func request(urlStr: String, method: NetMethod = .POST,  parameter: Parameter? = nil, handler:@escaping (_ response: NetResponse)->()){
        
//        let response = NetResponse()
//        response.parameter = [
//            "flag": 1,
//            "message": "请求成功",
//            "user": [
//                "id": "1",
//                "nickname": "斗兽菜菜",
//                "avatar": "http://xxx.com/upload/avatar/xxxx.png",
//            ]
//        ]
//        handler(response)
//
//        return
        
        var urlString = urlStr
        //如果是get方式，且有参数，进行字符串拼接
        if method == .GET && parameter != nil{
            //调用字符串拼接的方法
            if let parStr = self.parameterStr(parameter!)
                .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
                urlString = "\(urlStr)?\(parStr)"
            }
        }
        guard let url = URL(string: urlString) else {
            //url格式错误
            handler(NetResponse(error: .url))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        //如果是POST方式，设置httpBody的值
        if method == .POST{
            let data = self.parameterStr(parameter!).data(using: String.Encoding.utf8)
            request.httpBody = data
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                //请求结果
                handler(NetResponse(response: response, data: data, error: error))
            }
        }
        task.resume()
    }
    
    //拼接请求参数为字符串
    func parameterStr(_ parameter: Parameter)->String{
        var str = ""
        for key in parameter.keys{
            var value = parameter[key]
            if value == nil{
                value = ""
            }
            str += "\(key)=\(value!)&"
        }
        return str
    }
}

enum NetError: Error{
    case url //请求地址格式出错
    case netWork //网络异常
    case noSource //无法访问资源
    case serverWrong //服务器出错
    case parameter //参数格式错误
    case other //其它错误
}

class NetResponse: NSObject{
    
    var response: HTTPURLResponse?
    var error: NetError?
    var parameter: Parameter?
    
    override init() {
        super.init()
    }
    
    init(error: NetError) {
        self.error = error
    }
    
    init(response: URLResponse?, data: Data?, error: Error?){
        super.init()
        if error != nil{
            self.error = .netWork
            return
        }
        guard let httpRespose = response as? HTTPURLResponse else{
            self.error = .serverWrong
            return
        }
        self.response = httpRespose
        
        if httpRespose.statusCode == 404{
            self.error = .noSource
            return
        }
        if httpRespose.statusCode == 500{
            self.error = .serverWrong
            return
        }
        //返回参数 不等于200设置为其他错误
        if httpRespose.statusCode != 200{
            self.error = .other
            return
        }
        //不存在data
        if data  == nil{
            self.error = .serverWrong
            return
        }
        //data解析成字典
        if let dict = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? Parameter{
            self.parameter = dict
        }else{
            self.error = .parameter
        }
    }
}
