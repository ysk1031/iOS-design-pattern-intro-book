//
//  Api.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import Foundation

enum ApiError: Error, CustomStringConvertible {
    case unknown, invalidUrl, invalidResponse
    
    var description: String {
        switch self {
        case .unknown: return "不明なエラー"
        case .invalidUrl: return "無効なURL"
        case .invalidResponse: return "フォーマットが無効なレスポンス"
        }
    }
}

final class Api {
    func getUsers(success: @escaping ([User]) -> Void,
                  failure: @escaping (Error) -> Void)
    {
        guard let url = URL(string: "https://api.github.com/users") else {
            failure(ApiError.invalidUrl)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(ApiError.unknown)
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            guard let users: [User] = try? jsonDecoder.decode([User].self, from: data) else {
                DispatchQueue.main.async {
                    failure(ApiError.invalidResponse)
                }
                return
            }
            
            DispatchQueue.main.async {
                success(users)
            }
        }
        task.resume()
    }
}
