//
//  Configuration.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Foundation

final class Configuration {
    static let shared = Configuration()
        
    let baseApiURL = URL(string: "https://newsapi.org/v2/")!
    let apiKey = "dc82f5caf3ac49a2bffdd0bebe205ec7"
}
