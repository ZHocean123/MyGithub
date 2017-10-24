//
//  SearchApi.swift
//  MyGithub
//
//  Created by yang on 19/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import DefaultsKit

let SearchPrvider = MoyaProvider<Search>(plugins: [loggerPlugin])

enum RepoSort: String {
    case stars
    case forks
    case updated
}

enum RepoOrder: String {
    case asc
    case desc
}

enum Search {
    // TODO:高级搜索
    case repositories(q: String,
                      sort: RepoSort?,
                      order: RepoOrder?,
                      pagination: Pagination?)
}

extension Search: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "token " + (KeychainSwift().get("accessToken") ?? "")
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
        case .repositories:
            return "search/repositories"
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "")!
    }

    var task: Task {
        switch self {
        case .repositories(let q, let sort, let order, let pagination):
            var parameters: [String: Any] = ["q": q]
            if let sort = sort {
                parameters["sort"] = sort.rawValue
                if let order = order {
                    parameters["order"] = order.rawValue
                }
            }
            if let pagination = pagination {
                pagination.param.forEach({ (key, value) in
                    parameters[key] = value
                })
            }
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        }
    }
}
