//
//  NewsRouter.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Alamofire

public enum NewsRouter: Router {
    case getTopHeadlines
    case getAllNews
    
    public var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    public var path: String {
        switch self {
        case .getTopHeadlines:
            return "top-headlines"
        case .getAllNews:
            return "everything"
        }
    }
}
