//
//  ServiceManager.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 31.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseResult <Value> {
    case success(Value)
    case error(message: String)
}

typealias AuthCompletion = (ResponseResult<Bool>) -> Void

class ServiceManager {
    
    static let shared = ServiceManager()
    
    private init() {}
    
    fileprivate(set) var token: AccessToken?
    
    
    //MARK: - Auth
    
    func sendLogin(login: String, password: String, completion: @escaping AuthCompletion) {
        
        Alamofire
            .request(AuthRouter.loginUser(login: login, password: password))
            .responseJSON { (dataResponse) in
                
                guard let response = dataResponse.result.value as? [String: Any] else {
                    completion(.error(message: "Something went wrong"))
                    return
                }
                
                debugPrint("Logged In: \(response)")
                
                let success = !(response["error"] as! Bool)
                let token = response["access_token"] as! [String: Any]
                
                let expires = token["expires_in"] as! Int
                let userId = token["user_id"] as! Int
                let tokenString = token["token_string"] as! String
                
                self.token = AccessToken(string: tokenString, expiresIn: Double(expires), userId: userId)
                
                completion(.success(success))
        }
    }
    
    func sendRegister(email: String, login: String, password: String, completion: @escaping AuthCompletion) {
        
        Alamofire
            .request(AuthRouter.registerUser(email: email, login: login, password: password))
            .responseJSON { (dataResponse) in
                
                guard let response = dataResponse.result.value as? [String: Any] else {
                    completion(.error(message: "Something went wrong"))
                    return
                }
                
                debugPrint("Logged In: \(response)")
                
                let success = !(response["error"] as! Bool)
                guard success else {
                    completion(.error(message: "Something went wrong"))
                    return
                }
                let token = response["access_token"] as! [String: Any]
                
                let expires = token["expires_in"] as! Int
                let userId = token["user_id"] as! Int
                let tokenString = token["token_string"] as! String
                
                self.token = AccessToken(string: tokenString, expiresIn: Double(expires), userId: userId)
                
                completion(.success(success))
        }
    }
    
    
    func loadPosts(for group: String, offset: Int, count: Int, completion: @escaping ([Post]) -> Void) {
        Alamofire
            .request(PostRouter.loadPosts(group: group, offset: offset, count: count, userId: self.token!.userId))
            .responseJSON { (dataResponse) in
                
                guard let response = dataResponse.result.value as? [String: Any] else {
                    completion([])
                    return
                }
                let jsonPosts = response["posts"] as! [[String: Any]]
                let posts = jsonPosts.map { Post(with: $0) }
                
                completion(posts)
        }
    }
}


//MARK: - Auth Routing
enum AuthRouter: URLRequestConvertible {
    
    private static let baseURLString = "\(Constants.baseApiServicePath)/auth"
    
    case loginUser(login: String, password: String)
    case registerUser(email: String, login: String, password: String)
    
    private var method: HTTPMethod {
        return .post
    }
    
    private var path: String {
        switch self {
        case .loginUser:
            return "/login"
        case .registerUser:
            return "/signup"
        }
    }
    
    
    //MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try AuthRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case let .loginUser(login, password):
            let params = ["login": login, "password": password]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            
        case let .registerUser(email, login, password):
            let params = ["email": email, "login": login, "password": password]
            urlRequest = try URLEncoding.default.encode(urlRequest, with:params)
        }
        return urlRequest
    }
}


enum PostRouter: URLRequestConvertible {
    
    private static let baseURLString = "\(Constants.baseApiServicePath)/posts"
    
    case loadPosts(group: String, offset: Int, count: Int, userId: Int)
    
    private var method: HTTPMethod {
        return .post
    }
    
    private var path: String {
        return "/list"
    }
    
    
    //MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try PostRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case let .loadPosts(group, offset, count, userId):
            let params = ["group_domain": group, "offset": offset, "count": count, "user_id": userId] as [String : Any]
            urlRequest = try URLEncoding.default.encode(urlRequest, with:params)
        }
        return urlRequest
    }
}
