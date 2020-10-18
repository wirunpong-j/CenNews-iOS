//
//  APIManager.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Alamofire
import Foundation

typealias APICompletionBlock<T: Decodable> = (_ result: Result<T, BaseError>) -> Void

class NetworkService {
    public let session: Session = {
        return Session.default
    }()
    
    @discardableResult
    func performRequest<T: Decodable>(_ request: URLRequestConvertible, completion: @escaping APICompletionBlock<T>) -> DataRequest {

        let dataRequest = session
            .request(request)
            .responseData(completionHandler: { response in
                NetworkService.logResponse(response: response)
                
                switch response.result {
                case .success(let data):
                    do {
                        let object = try JSONDecoder().decode(BaseResponse<T>.self, from: data)
                        switch object.status {
                        case .success:
                            if let data = object.data {
                                completion(.success(data))
                            } else {
                                completion(.failure(BaseError(message: object.message)))
                            }
                        default:
                            completion(.failure(BaseError(message: object.message)))
                        }
                    } catch {
                        completion(.failure(BaseError(message: error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.failure(BaseError(message: error.localizedDescription)))
                }
            })

        return dataRequest
    }
}
