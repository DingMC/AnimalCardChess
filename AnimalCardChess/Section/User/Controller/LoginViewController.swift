//
//  LoginViewController.swift
//  AnimalCardChess
//
//  Created by masun on 2018/1/1.
//  Copyright © 2018年 dimgnc. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(Color.textH, for: .normal)
        btn.titleLabel?.font = Font.middle
        btn.addTarget(self, action: #selector(self.cancelLogin), for: .touchUpInside)
        return btn
    }()
    
    //账号输入框
    lazy var accountTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.textAlignment = .center
        tf.textColor = Color.textH
        tf.font = Font.middle
        tf.placeholder = "请输入账号"
        tf.text = "abc"
        return tf
    }()
    
    //密码输入框
    lazy var pwdTextField: UITextField  = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.textAlignment = .center
        tf.textColor = Color.textH
        tf.font = Font.middle
        tf.placeholder = "请输入密码"
        tf.text = "123"
        return tf
    }()
    
    //登录按钮
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(Color.textH, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(self.didLoginButton), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createView()
        self.createSnp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createView(){
        self.view.addSubview(self.cancelButton)
        
        self.view.addSubview(self.accountTextField)
        self.view.addSubview(self.pwdTextField)
        self.view.addSubview(self.loginButton)
    }
    
    func createSnp(){
        
        self.accountTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(44)
        }
        self.pwdTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.accountTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.accountTextField)
            make.height.equalTo(44)
        }
        self.loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.pwdTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.accountTextField)
            make.height.equalTo(44)
        }
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.top.equalTo(self.loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
    
    @objc func didLoginButton(){
        guard let account = self.accountTextField.text, account != "" else{
            MCLoading.shared.alert("请先填写账号")
            return
        }
        guard let password = self.pwdTextField.text, password != "" else{
            MCLoading.shared.alert("请先填写密码")
            return
        }
        MCLoading.shared.startLoading(text: "登录中...")
        UserManager.shared.login(account, password: password) { (errorMsg) in
            if errorMsg == nil{
                //登录成功
                MCLoading.shared.stopLoading("登录成功")
                self.dismiss(animated: true, completion: nil)
            }else{
                //登录失败
                MCLoading.shared.stopLoading("登录失败")
            }
        }
    }
    @objc func cancelLogin(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
