//
//  ViewController.swift
//  CallSwiftFromJS
//
//  Created by 葛慧 on 2017/3/31.
//  Copyright © 2017年 葛慧. All rights reserved.
//

import UIKit
import JavaScriptCore


@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    // js调用App的微信支付功能 演示最基本的用法
    func wxPay(orderNo: String)
    
    // js调用App的微信分享功能 演示字典参数的使用
    func wxShare(dict: [String: AnyObject])
    
    
    
}

// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addWebView()
    }
    
    func addWebView() {
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        
        // 加载本地Html页面
        let path = Bundle.main.url(forResource: "demo", withExtension: "html")
        let request = URLRequest(url: path!)
        
        // 加载网络Html页面 请设置允许Http请求
        //let url = NSURL(string: "http://www.mayanlong.com");
        //let request = NSURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = self.jsContext
        
        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS就可以通过WebViewJavascriptBridge调用我们暴露的方法了。
        self.jsContext.setObject(model, forKeyedSubscript: "WebViewJavascriptBridge" as NSCopying & NSObjectProtocol)
        
        // 注册到本地的Html页面中
        let url = Bundle.main.url(forResource: "demo", withExtension: "html")
        let g_home_url = try?String(contentsOf: url!, encoding: String.Encoding.utf8)
        self.jsContext.evaluateScript(g_home_url)
        
        // 注册到网络Html页面 请设置允许Http请求
        //let url = "http://www.mayanlong.com";
        //let curUrl = self.webView.request?.URL?.absoluteString    //WebView当前访问页面的链接 可动态注册
        //self.jsContext.evaluateScript(try? String(contentsOfURL: NSURL(string: url)!, encoding: NSUTF8StringEncoding))
        
        self.jsContext.exceptionHandler = { (context, exception) in
            print("exception：", exception ?? "exception")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

