//
//  Client+Initialization.swift
//
//
//  Created by Nicolas Märki on 26.06.2024.
//

import OpenAPIRuntime
import Foundation
import OpenAPIURLSession
import HTTPTypes

public extension Client {
    init(serverURL: URL? = nil, key: String, beta: Bool = true) throws {
        var middlewares: [ClientMiddleware] = [AuthMiddleware(key: key)]
        if beta{
            middlewares.append(BetaMiddleware())
        }
        let url = try serverURL ?? Servers.Server1.url()
        self.init(serverURL: url, transport: URLSessionTransport(), middlewares: middlewares)
    }
}
