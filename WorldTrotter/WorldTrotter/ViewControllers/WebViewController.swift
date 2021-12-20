//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by cx on 2021/12/21.
//

import UIKit
import WebKit
class WebViewController: UIViewController,WKUIDelegate
{
    var webView:WKWebView!
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"https://www.baidu.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        print("WebViewController loaded it's view")
    }
}
