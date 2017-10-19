//
//  AuthViewController.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import DefaultsKit

class AuthViewController: UIViewController, WKNavigationDelegate {

    var disposeBag = DisposeBag()
    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webview.navigationDelegate = self
        for cookie in HTTPCookieStorage.shared.cookies ?? [] {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webview.load(URLRequest(url: URL(string: "https://github.com/login/oauth/authorize?client_id=" + clientId)!))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        print("action url:" + (url?.absoluteString)!)
        if let urlStr = url?.absoluteString, urlStr.hasPrefix("https://localhost/?code=") {
            let startSlicingIndex = urlStr.index(urlStr.startIndex, offsetBy: "https://localhost/?code=".characters.count)
            let code = urlStr[startSlicingIndex...]
            print("code:" + code)
            getAccessToken(String(code))
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(webView.url?.description ?? "no url")
    }

    @IBAction func closeController(_ sender: Any) {
        dismiss(animated: true) {

        }
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthViewController {
    func getAccessToken(_ code: String) {
        disposeBag = DisposeBag()
        GithubAuthPrvider.rx.request(.oAuth(client_id: clientId, client_secret: client_secret, code: code)).mapString().subscribe { [weak self] (event) in
            switch event {
            case .success(let str):
                var params = [String: String]()
                let valueStrs = str.split(separator: "&")
                for valueStr in valueStrs {
                    let array = valueStr.split(separator: "=")
                    let key = array.count > 0 ? String(array[0]) : ""
                    let value = array.count > 1 ? String(array[1]) : ""
                    params[key] = value
                }
                print(params)
                if let accessToken = params["access_token"] {
                    Defaults.shared.set(accessToken, for: accessTokenKey)
                    self?.dismiss(animated: true, completion: {
                        
                    })
                }
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }
}
