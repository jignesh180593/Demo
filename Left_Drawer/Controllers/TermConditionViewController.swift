//
//  TermConditionViewController.swift
//  Left_Drawer
//
//  Created by admin on 04/03/21.
//  Copyright © 2021 Romal Tandel. All rights reserved.
//

import UIKit
import WebKit

class TermConditionViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Terms & Conditions"
        webView.frame = view.bounds
               webView.navigationDelegate = self

               let url = URL(string: "https://pulsehospitaljammu.com/Terms")!
               let urlRequest = URLRequest(url: url)

               webView.load(urlRequest)
               webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
               view.addSubview(webView)
        
        // Do any additional setup after loading the view.
        if revealViewController() != nil {
           menuButton.target = revealViewController()
           menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
           self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    let host = url.host, !host.hasPrefix("www.google.com"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    print(url)
                    print("Redirected to browser. No need to open it locally")
                    decisionHandler(.cancel)
                } else {
                    print("Open it locally")
                    decisionHandler(.allow)
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
            }
        }
}
