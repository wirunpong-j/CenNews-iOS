//
//  BaseResponse.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Foundation

enum ResponseStatus: String {
    case success = "ok", failure = "error"
}

struct BaseResponse<T: Decodable>: Decodable {
    let status: ResponseStatus?
    let code: String?
    let message: String?
    let data: T?
    
    private enum CodingKeys: String, CodingKey {
        case status, code, message, articles, sources
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try? container.decode(String.self, forKey: .code)
        message = try? container.decode(String.self, forKey: .message)
        
        if let status = try? container.decode(String.self, forKey: .status) {
            self.status = ResponseStatus(rawValue: status)
        } else {
            self.status = nil
        }
        
        if let articles = try? container.decode(T.self, forKey: .articles) {
            self.data = articles
        } else if let sources = try? container.decode(T.self, forKey: .sources) {
            self.data = sources
        } else {
            self.data = nil
        }
    }
}
