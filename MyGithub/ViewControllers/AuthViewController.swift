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
    var scopes: [GithubScope] = []
    var state = ""

    let keychain = KeychainSwift()
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

        // set random state string
        state = "123123"

        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: "https://localhost/github_callbak"),
            URLQueryItem(name: "scope", value: scopes.map({ "\($0.rawValue)" }).joined(separator: ",")),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "allow_signup", value: "true")
        ]

        webview.load(URLRequest(url: components.url!,
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        print("action url:" + (url.absoluteString))
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            components.path == "/github_callbak" {
            var code: String
            for queryItem in components.queryItems ?? [] where queryItem.name == "code" {
                if let value = queryItem.value {
                    code = value
                    print("code:" + code)
                    getAccessToken(String(code))
                } else {
                    print("emptyCode")
                }
                break
            }
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
                    if let strongSelf = self, !strongSelf.keychain.set(accessToken, forKey: "accessToken") {
                        
                    } else {
                        self?.dismiss(animated: true, completion: {

                        })
                    }
                    Defaults.shared.set(accessToken, for: accessTokenKey)
                }
            case .error(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
}
