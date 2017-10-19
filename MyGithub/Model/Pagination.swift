//
//  Pagination.swift
//  MyGithub
//
//  Created by yang on 19/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation

struct Pagination {
    var page: Int = 1
    var perPage: Int = 30

    var param: [String: Any] {
        return ["page": page, "per_page": perPage]
    }
}
