//
//  ViewController.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import RxSwift
import DefaultsKit

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController")
//
//        present(authViewController, animated: true) {
//
//        }
        if Defaults.shared.get(for: userInfoKey) != nil {
//            let repositoriesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepositoriesViewController")
//            navigationController?.pushViewController(repositoriesViewController, animated: true)
        } else {
            disposeBag = DisposeBag()
            GithubPrvider.rx.request(.user)
                .mapObject(UserInfo.self)
                .subscribe { (event) in
                    switch event {
                    case .success(let userInfo):
                        print(userInfo)
                        Defaults.shared.set(userInfo, for: userInfoKey)
                    case .error(let error):
                        print(error)
                    }
                }.disposed(by: disposeBag)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

