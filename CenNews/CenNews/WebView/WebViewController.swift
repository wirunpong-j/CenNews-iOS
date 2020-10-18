//
//  WebViewController.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 18/10/2563 BE.
//

import WebKit
import UIKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var urlRequest: URLRequest!
    
    private lazy var loadingView = LoadingIndicatorView(view: webView)
    
    init(url: URL, title: String? = nil) {
        self.urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        createWebView()
    }

    private func createWebView() {
        webView?.navigationDelegate = self
        webView?.removeFromSuperview()
        
        let originalURL = webView?.url ?? urlRequest?.url
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)

        view.addConstraints([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        self.webView = webView
        loadingView.start()
        
        if let url = originalURL {
            loadURLRequest(URLRequest(url: url))
        }
    }

    private func loadURLRequest(_ request: URLRequest) {
        print("Load \(request)")
        urlRequest = request
        
        guard isViewLoaded else {
            return
        }
        
        webView.load(request)
    }

    // MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let cred = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, cred)
        } else {
            completionHandler(.useCredential, nil)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = navigationItem.title ?? webView.title ?? "News"
        loadingView.stop()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView.stop()
    }
}
