//
//  HomeViewController.swift
//  AnimalCardChess
//
//  Created by masun on 2017/12/18.
//  Copyright © 2017年 dimgnc. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController{
    
    
    lazy var tv: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    var cellArray = [HomeItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createData()
        self.createView()
        self.createSnp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createData(){
        self.cellArray.append(HomeItem(name: "双人对战", key: "outline"))
        self.cellArray.append(HomeItem(name: "人机练习", key: "AI"))
        self.cellArray.append(HomeItem(name: "联网对战", key: "online"))
    }
    
    func createView(){
        self.view.addSubview(self.tv)
    }
    
    func createSnp(){
        self.tv.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(CGFloat(self.cellArray.count)*50)
        }
    }
    
    //开始匹配
    func startMatch(){
        guard let user = UserManager.shared.user else{
            return
        }
        
        let parameter: Parameter = ["uid": user.id]
        
        NetworkUtil.shared.request(urlStr: APIDefine.Composition.matching, parameter: parameter) { (response) in
            guard let result = response.parameter?["result"] as? Parameter else{
                return
            }
            
            guard let type = result["type"] as? String else{
                return
            }
            
            if type == "wait"{
                //匹配中...开始检测匹配结果...
                MessageManager.shared.matchingDelegate = self
                return
            }
            
            if type == "start"{
                //匹配成功...开局...
                self.startOnlineGame(result)
                return
            }
        }
    }
    
    //根据开局数据开局
    func startOnlineGame(_ dict: Parameter){
        guard let user = UserManager.shared.user else{
            return
        }
        guard let composition_id = dict["id"] as? String else{
            return
        }
        guard let start_position = dict["start_position"] as? [Int] else{
            return
        }
        guard let player_one_dict = dict["player_one"] as? Parameter else{
            return
        }
        guard let player_two_dict = dict["player_one"] as? Parameter else{
            return
        }
        
        do{
            let player_one = try JSONDecoder().decode(Player.self, from: player_one_dict.data()!)
            let player_two = try JSONDecoder().decode(Player.self, from: player_two_dict.data()!)
            let to_vc = CompositionViewController()
            to_vc.type = 2
            
            //判断哪一个是玩家是自己，将自己置于playerOne。
            if player_one.id == user.id{
                 CompositionManager.shared.playerJoin(playerOne: player_one, playerTwo: player_two)
            }else{
                CompositionManager.shared.playerJoin(playerOne: player_two, playerTwo: player_one)
            }
            CompositionManager.shared.curPlayer = player_one
            //根据返回的start_position数据生成随机的棋局
            let composition = Composition(id: composition_id, startChesses: CompositionUtil.createQue(start_position))
            CompositionManager.shared.compositionCreate(composition: composition)
            self.present(to_vc, animated: true, completion: nil)
        }catch{
            
        }
    }
    
}
extension HomeViewController: MatchingProtocol{
    func matchingSucceed(_ dict: [String : Any]) {
        //监听到成功...开局...
        self.startOnlineGame(dict)
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.cellArray[indexPath.row]
        let cell = HomeTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.update(object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.cellArray[indexPath.row]
        let to_vc = CompositionViewController()
        
        //根据key值判断不同类型的游戏方式，后期做不同的处理
        switch object.key {
        case "outline":
            to_vc.type = 0
            let player1 = Player(id: "1", name: "玩家1", avatar: "")
            let player2 = Player(id: "2", name: "玩家2", avatar: "")
            CompositionManager.shared.playerJoin(playerOne: player1, playerTwo: player2)
            
            let composition = Composition(id: "1", startChesses: CompositionUtil.randomQue())
            CompositionManager.shared.compositionCreate(composition: composition)
            break
        case "AI":
            to_vc.type = 1
            let player1 = Player(id: "1", name: "玩家1", avatar: "")
            var player2 = Player(id: "2", name: "简单的电脑玩家", avatar: "")
            player2.isAI = true
            CompositionManager.shared.playerJoin(playerOne: player1, playerTwo: player2)
            
            let composition = Composition(id: "1", startChesses: CompositionUtil.randomQue())
            CompositionManager.shared.compositionCreate(composition: composition)
            break
        case "online":
            if UserManager.shared.loginStatus == .logined{
                self.startMatch()
            }else if UserManager.shared.loginStatus == .logining{
                print("连接中，请稍后。")
            }else{
                let to_vc = LoginViewController()
                self.present(to_vc, animated: true, completion: nil)
            }
            return
        default:
            break
        }
        self.present(to_vc, animated: true, completion: nil)
    }
    
}




