//
//  ViewController.swift
//  CallSwiftFromJS
//
//  Created by 葛慧 on 2017/3/31.
//  Copyright © 2017年 葛慧. All rights reserved.
//

import UIKit
import JavaScriptCore
import Foundation


@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    
    func getUserID() -> String
    
    func getUserName() -> String
    
    func Back()
    
    func goToInternet(_ url:String)
    
}

// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {


    
    weak var controller: ViewController?
    weak var jsContext: JSContext?
    
    
    func getUserID() -> String
    {
        
        print("get user id")
        return "310072"
    }
    
    func getUserName() -> String
    {
        print("get user name")
        return "葛"
    }

    func Back()
    {
        controller?.removeWebView()
        print("Back()")
    }
    
    func goToInternet(_ url:String)
    {
        UIApplication.shared.openURL(NSURL(string: url)! as URL)
        print("goToInternet")
    }
    
}

class ViewController: UIViewController, TSWebViewDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
  
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var txtPwd: UITextField!
    
    var webView: UIWebView!
    var jsContext: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        addWebView()
    }
    
    
    @IBAction func onFindPWD(_ sender: Any) {
    }
    
    
    public func removeWebView()
    {
        DispatchQueue.main.async(){
           self.webView.removeFromSuperview()
        }

        
    }
    
    
    func addWebView() {
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20 ))
    
        self.view.addSubview(self.webView)
        self.webView.delegate = self
        
        
        
        
//        self.webView.scalesPageToFit = true
        
        // 加载本地Html页面
//        let path = Bundle.main.url(forResource: "demo", withExtension: "html")
//        let g_home_url = try?String(contentsOf: path!, encoding: String.Encoding.utf8)
//        self.webView.loadHTMLString(g_home_url!, baseURL: nil)
//        let request = URLRequest(url: path!)
        
        // 加载网络Html页面 请设置允许Http请求
//        let path = NSURL(string: "http://www.baidu.com");
        let path = NSURL(string: "http://dzhy.weiedi.com/ecShop/front/home");
        let request = NSURLRequest(url: path! as URL)
        
        self.webView.loadRequest(request as URLRequest)
    }
    
    

    
    func webView(_ webView: UIWebView, didCreateJavaScriptContext ctx: JSContext) {
        
        self.jsContext = ctx;
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = self.jsContext
        
        self.jsContext.setObject(model, forKeyedSubscript: "nativeApis" as NSCopying & NSObjectProtocol)
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception：", exception ?? "exception")
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        print("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        print("webViewDidFinishLoad")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

