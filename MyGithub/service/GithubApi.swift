//
//  GithubApi.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import DefaultsKit

var accessToken = Defaults.shared.get(for: accessTokenKey)

let GithubPrvider = MoyaProvider<Github>(plugins: [loggerPlugin])
enum Github {
    case user
    case repositories(
        visibility: RepositoryVisibility?,
        affiliation: RepositoryAffiliation?,
        type: RepositoryType?,
        sort: RepositorySortType?,
        direction: RepositoryDirection?)
    case repository(owner: String, repo: String)
}

extension Github: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "token " + (accessToken ?? "")
        ]
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .user:
            return "user"
        case .repositories:
            return "user/repos"
        case .repository(let owner, let repo):
            return "repos/\(owner)/\(repo)"
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "")!
    }

    var task: Task {
        switch self {
        case .repositories(let visibility,
                           let affiliation,
                           let type,
                           let sort,
                           let direction):
            var parameters = [String: Any]()
            if let visibility = visibility {
                parameters["visibility"] = visibility.rawValue
            }
            if let affiliation = affiliation {
                parameters["affiliation"] = affiliation.stringValue
            }
            if let type = type {
                parameters["type"] = type.rawValue
            }
            if let sort = sort {
                parameters["sort"] = sort.rawValue
            }
            if let direction = direction {
                parameters["direction"] = direction.rawValue
            }
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
}
