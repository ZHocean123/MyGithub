//
//  RepositorySearchViewController.swift
//  MyGithub
//
//  Created by yang on 13/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import RxSwift

class RepositorySearchViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var disposeBag = DisposeBag()
    var repositories = [SearchRepositoryResult.Item]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        disposeBag = DisposeBag()
        GithubPrvider.rx.request(.searchRepositories(key: "al"))
            .mapObject(SearchRepositoryResult.self)
            .subscribe { [weak self] (event) in
                switch event {
                case .success(let result):
                    self?.repositories = result.items
                    self?.tableview.reloadData()
                case .error(let error):
                    print(error.errorMessage)
                }
            }.disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        cell.textLabel?.text = repositories[indexPath.row].name
        return cell
    }
}
