//
//  NetworkService+Log.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Alamofire
import Foundation

extension NetworkService {
    public static func logRequest(urlRequest: URLRequest?) {
        guard let urlRequest = urlRequest else { return }
        
        NetworkService.logDivider(start: true)
        NetworkService.logPath(url: urlRequest.url, withKey: "REQUEST")
        NetworkService.logHTTPMethod(request: urlRequest)
        NetworkService.logHeaders(headers: urlRequest.allHTTPHeaderFields)
        if let method = urlRequest.httpMethod, ["POST", "PATCH", "PUT"].contains(method.uppercased()) {
            NetworkService.logJson(data: urlRequest.httpBody)
        }
        NetworkService.logDivider(start: false)
    }
    
    public static func logResponse(response: DataResponse<Data, AFError>) {
        guard let httpResponse = response.response else { return }

        self.logDivider(start: true)
        self.logPath(url: httpResponse.url, withKey: "RESPONSE")
        self.logStatus(httpResponse: httpResponse)
//        self.logHeaders(headers: httpResponse.allHeaderFields as? [String : String])
        self.logJson(data: response.data)
        self.logDivider(start: false)
    }

    public static func logDivider(start: Bool) {
        if start {
            print("|-------------------------------------------------")
        } else {
            print("-------------------------------------------------|")
        }
    }

    public static func logPath(url: URL?, withKey key: String) {
        guard let url = url else { return }
        print("\(key): \(url.absoluteString)")
    }

    public static func logStatus(httpResponse: HTTPURLResponse) {
        let status = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode).capitalized
        print("STATUS: \(httpResponse.statusCode) - \(status)")
    }

    public static func logHeaders(headers: [String: String]?) {
        guard let headers = headers else { return }

        if headers.count > 0 {
            print("HEADERS: [")
            for (key, value) in headers {
                print("   \(key): \(value)")
            }
            print("]")
        }
    }

    public static func logJson(data: Data?) {
        guard let data = data else { return }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let pretty = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                if let string = String(data: pretty, encoding: .utf8) {
                    print("JSON: \(string)")
                }
            } else {
                print("ERROR: Couldn't create json object from returned data")
                let string = String(data: data, encoding: .utf8) ?? ""
                print("DATA STRING: \(string)")
            }
        } catch {
            print("ERROR: \(error)")
        }
    }

    public static func logHTTPMethod(request: URLRequest) {
        guard let method = request.httpMethod else { return }
        print("METHOD: \(method)")
    }
}
