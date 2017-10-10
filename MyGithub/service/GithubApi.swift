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

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let loggerPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
let GithubPrvider = RxMoyaProvider<Github>(plugins: [loggerPlugin])
enum Github {
    case user
    case repository(owner: String, repo: String)
}

extension Github: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var headers: [String: String]? {
        return nil
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
        case .repository(let owner, let repo):
            return "repos/" + owner + "/" + repo
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "")!
    }

    var task: Task {
        switch self {
        default:
            return .requestParameters(parameters: ["access_token" : accessToken ?? ""],
                                      encoding: URLEncoding.default)
        }
    }
}
