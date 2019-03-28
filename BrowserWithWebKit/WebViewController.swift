//
//  WebViewController.swift
//  BrowserWithWebKit
//
//  Created by Niraj Jha on 27/03/19.
//  Copyright © 2019 Niraj Jha. All rights reserved.
//

import UIKit
import WebKit

typealias VoidBlock = () -> Void

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "yahoo.com"]
    
    //MARK:- Life cycle
    
    // gets called before ViewDidLoad
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
       
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        
        toolbarItems = [progressButton, spacer, refresh]
        
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        
        // Force unwrap as it is safe
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc private func openTapped() {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
             ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // for iPAd:- it tells iOS where to anchor this action sheet
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem

        present(ac, animated: true)
        
        //alternateMethod
        
       /**
         alternate method
         let openBlock = { [weak self] in
           let url = URL(string: "https://apple.com")!
            guard let self = self else { return }
            self.webView.load(URLRequest(url: url))
        }

        open(openHandler: openBlock) */
        
    }

    //MARK:- private
    func openPage(action: UIAlertAction) {
        
        guard let actionTitle = action.title,
            let url = URL(string: "https://" + actionTitle)
            else { return }
       
        webView.load(URLRequest(url: url))
        
    }
    
   /** alternate method
     func open(openHandler: VoidBlock?) {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    
        let appleAction = UIAlertAction(title: "apple.com", style: .default) { _ in
            openHandler?()
        }
        ac.addAction(appleAction)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // for iPAd:- it tells iOS where to anchor this action sheet
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
    } */
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // set navigation title as website loaded
        title = webView.title
    }
    
    // allows navigation or not
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
    
    //MARK:- Key value observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        
    }

}

