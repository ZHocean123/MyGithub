//
//  ApiParser.swift
//  MyGithub
//
//  Created by yang on 10/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension Response {
    // 这一个主要是将JSON解析为单个的Model
    public func mapObject<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard self.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: self.data) {
                throw(ResponseError(errorResponse))
            }
            throw(ResponseError(String(self.statusCode)))
        }
        do {
            let object = try JSONDecoder().decode(T.self, from: self.data)
            return object
        } catch(let err) {
            throw(err)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    // 这个是将JSON解析为Observable类型的Model
    public func mapObject<T: Decodable>(_ type: T.Type) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(T.self))
        }
    }
}

