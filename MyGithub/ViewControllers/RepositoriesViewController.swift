//
//  RepositoriesViewController.swift
//  MyGithub
//
//  Created by yang on 11/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import DefaultsKit
import RxSwift

class RepositoriesViewController: UIViewController {

    var disposeBag = DisposeBag()
    var repositories = [RepositoryTableViewCellLayout]()
    let userInfo = Defaults.shared.get(for: userInfoKey)

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        disposeBag = DisposeBag()
        GithubPrvider.rx.request(.repositories(visibility: nil,
                                               affiliation: nil,
                                               type: nil,
                                               sort: .updated,
                                               direction: .asc))
            .mapObject([Repository].self)
            .subscribe { [weak self] (event) in
                switch event {
                case .success(let repositories):
                    self?.repositories = repositories.map({ (repository) -> RepositoryTableViewCellLayout in
                        return RepositoryTableViewCellLayout(repository)
                    })
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

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryTableViewCell
        cell.nameLabel.text = repositories[indexPath.row].repository.name
        cell.descriptionLabel.text = repositories[indexPath.row].repository.description

        cell.descriptionView.layout = repositories[indexPath.row].layout
        cell.languageButton.setTitle(repositories[indexPath.row].repository.language, for: .normal)
        cell.starsButton.setTitle(String(repositories[indexPath.row].repository.stargazersCount), for: .normal)
        cell.forksButton.setTitle(String(repositories[indexPath.row].repository.forks), for: .normal)
        return cell
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let cell = cell as? RepositoryTableViewCell {
//            cell.descriptionView.layout = repositories[indexPath.row].layout
//        }
//    }
}

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return repositories[indexPath.row].cellHeight
    }
}
