//
//  GithubAuth.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation
import Foundation
import Moya
import RxSwift

let GithubAuthPrvider = RxMoyaProvider<GithubAuth>(plugins: [loggerPlugin])
enum GithubAuth {
    case oAuth(client_id: String, client_secret: String, code: String)
}

extension GithubAuth: TargetType {
    var baseURL: URL {
        return URL(string: "https://github.com/login/oauth")!
    }

    var headers: [String: String]? {
        return nil
    }

    var method: Moya.Method {
        switch self {
        case .oAuth:
            return .post
        }
    }

    var path: String {
        switch self {
        case .oAuth:
            return "access_token"
        }
    }

    var sampleData: Data {
        return Data(base64Encoded: "")!
    }

    var task: Task {
        switch self {
        case .oAuth(let client_id, let client_secret, let code):
            return .requestParameters(parameters: ["client_id": client_id, "client_secret": client_secret, "code": code], encoding: URLEncoding.default)
        }
    }
}
