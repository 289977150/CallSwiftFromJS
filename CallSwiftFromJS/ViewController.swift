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
    
    // js调用App的微信支付功能 演示最基本的用法
    func wxPay(orderNo: String)
    
    // js调用App的微信分享功能 演示字典参数的使用
    func wxShare(dict: [String: AnyObject])
    
    
    
}

// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?//test
    weak var jsContext: JSContext?
    
    func getUserID() -> String
    {
        
        print("get user id")
        return "310071"
    }
    
    func getUserName() -> String
    {
        return "葛慧"
    }
    
    func wxPay(orderNo: String) {
        
        print("订单号：", orderNo)
        
        // 调起微信支付逻辑
    }
    
    func wxShare(dict: [String: AnyObject]) {
        
        print("分享信息：", dict)
        
        // 调起微信分享逻辑
    }
    
   
}

class ViewController: UIViewController, UIWebViewDelegate {

    var webView: UIWebView!    
    var jsContext: JSContext!
    var cnt:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cnt = 1
        addWebView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func addWebView() {
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        
        // 加载本地Html页面
        //let path = Bundle.main.url(forResource: "demo", withExtension: "html")
        //let g_home_url = try?String(contentsOf: path!, encoding: String.Encoding.utf8)
        //self.webView.loadHTMLString(g_home_url!, baseURL: nil)
        //let request = URLRequest(url: path!)
        
        // 加载网络Html页面 请设置允许Http请求
        let path = NSURL(string: "http://dzhy.weiedi.com/ecShop/front/order");
        let request = NSURLRequest(url: path! as URL)
        
        self.webView.loadRequest(request as URLRequest)
    }

   
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        if(self.cnt == 1)
        {
        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = self.jsContext
        
        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS就可以通过WebViewJavascriptBridge调用我们暴露的方法了。
        self.jsContext.setObject(model, forKeyedSubscript: "nativeApis" as NSCopying & NSObjectProtocol)
        
        // 注册到本地的Html页面中
        //let url = Bundle.main.url(forResource: "demo", withExtension: "html")
        //let g_home_url = try?String(contentsOf: url!, encoding: String.Encoding.utf8)
        //self.jsContext.evaluateScript(g_home_url)
        
        // 注册到网络Html页面 请设置允许Http请求
        let url = "http://dzhy.weiedi.com/ecShop/front/order";
        //let curUrl = self.webView.request?.URL?.absoluteString    //WebView当前访问页面的链接 可动态注册
        
        let htmlStr = try?String(contentsOf: NSURL(string: url)! as URL, encoding: String.Encoding.utf8)
        self.jsContext.evaluateScript(htmlStr)
        
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception：", exception ?? "exception")
        }
        }
        self.cnt = self.cnt + 1

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

