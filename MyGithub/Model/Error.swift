//
//  Error.swift
//  MyGithub
//
//  Created by yang on 11/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String
    struct Error: Codable {
        let resource: String
        let field: String
        let code: String
    }
    let errors: [Error]?
    let documentationUrl: URL?
    private enum CodingKeys: String, CodingKey {
        case message
        case errors
        case documentationUrl = "documentation_url"
    }
}

struct ResponseError: Error {
    let resource: String
    let field: String
    let code: String
    let message: String

    init(_ message: String) {
        self.message = message
        self.field = ""
        self.code = ""
        self.resource = ""
    }

    init(_ errorResponse: ErrorResponse) {
        self.message = errorResponse.message
        self.field = ""
        self.code = ""
        self.resource = ""
    }
}

extension Error {
    var errorMessage: String {
        if let responseError = self as? ResponseError {
            return responseError.message
        }
        return localizedDescription
    }
}
