//
//  Router.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Alamofire
import Foundation

public protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
}

struct Request<Parameters: Encodable>: URLRequestConvertible {
    let router: Router
    let parameters: Parameters
    
    init(router: Router, parameters: Parameters) {
        self.router = router
        self.parameters = parameters
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: router.path, relativeTo: Configuration.shared.baseApiURL)!
        var request = URLRequest(url: url)
        request.headers.update(.contentType("application/json;charset=utf-8"))
        request.method = router.method

        switch router.method {
        case .get:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        default:
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}
