//
//  NewsRequest.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import Foundation

enum NewsRequestSortByType: String {
    case relevancy, popularity, publishedAt
}

final class NewsRequest: Encodable {
    var query: String?
    var pageSize: Int?
    var pageNumber: Int?
    var country: String?
    var sortBy = NewsRequestSortByType.publishedAt
    
    private enum CodingKeys: String, CodingKey {
        case query = "q", pageSize, pageNumber = "page", sortBy, country, apiKey
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(query, forKey: .query)
        try? container.encode(pageSize, forKey: .pageSize)
        try? container.encode(pageNumber, forKey: .pageNumber)
        try? container.encode(sortBy.rawValue, forKey: .sortBy)
        try? container.encode(country, forKey: .country)
        try? container.encode(Configuration.shared.apiKey, forKey: .apiKey)
    }
}
