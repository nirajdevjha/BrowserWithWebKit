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
        
        // Force unwrap as it is safe
        let url = URL(string: "https://www.apple.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc private func openTapped() {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "yahoo.com", style: .default, handler: openPage))
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
    
    func open(openHandler: VoidBlock?) {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        /**
        alternate method
        let appleAction = UIAlertAction(title: "apple.com", style: .default) { _ in
            openHandler?()
        }
        ac.addAction(appleAction) */
        
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "yahoo.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // for iPAd:- it tells iOS where to anchor this action sheet
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // set navigation title as website loaded
        title = webView.title
    }
    


}

