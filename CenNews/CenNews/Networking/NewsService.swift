//
//  NewsService.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Alamofire

protocol NewsService {
    @discardableResult
    func getTopHeadlines(with form: NewsRequest, completion: @escaping APICompletionBlock<[Article]>) -> DataRequest
    @discardableResult
    func getAllNews(with form: NewsRequest, completion: @escaping APICompletionBlock<[Article]>) -> DataRequest
}

final class NewsRestService: NetworkService, NewsService {
    func getTopHeadlines(with form: NewsRequest, completion: @escaping APICompletionBlock<[Article]>) -> DataRequest {
        let router = NewsRouter.getTopHeadlines
        let request = Request(router: router, parameters: form)
        
        return performRequest(request, completion: completion)
    }
    
    func getAllNews(with form: NewsRequest, completion: @escaping APICompletionBlock<[Article]>) -> DataRequest {
        let router = NewsRouter.getAllNews
        let request = Request(router: router, parameters: form)
        
        return performRequest(request, completion: completion)
    }
}
