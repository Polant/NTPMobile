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
    
    fileprivate(set) var localUser: LocalUser?
    
    
    //MARK: - Auth
    
    func sendLogin(login: String, password: String, completion: @escaping AuthCompletion) {
        
        Alamofire
            .request(AuthRouter.loginUser(login: login, password: password))
            .responseJSON { (dataResponse) in
                
                guard let response = dataResponse.result.value as? [String: Any] else {
                    completion(.error(message: "Something went wrong"))
                    return
                }
                let success = !(response["error"] as! Bool)
                let email = response["user_email"] as! String
                
                let tokenDicrionary = response["access_token"] as! [String: Any]
                
                let expires = tokenDicrionary["expires_in"] as! Int
                let userId = tokenDicrionary["user_id"] as! Int
                let tokenString = tokenDicrionary["token_string"] as! String
                let token = AccessToken(string: tokenString, expiresIn: Double(expires))
                
                self.localUser = LocalUser(id: userId, login: login, email: email, token: token)
                
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
                let tokenDicrionary = response["access_token"] as! [String: Any]
                
                let expires = tokenDicrionary["expires_in"] as! Int
                let userId = tokenDicrionary["user_id"] as! Int
                let tokenString = tokenDicrionary["token_string"] as! String
                
                let token = AccessToken(string: tokenString, expiresIn: Double(expires))
                self.localUser = LocalUser(id: userId, login: login, email: email, token: token)
                
                completion(.success(success))
        }
    }
    
    
    func loadPosts(forAppWithId appId: Int, offset: Int, count: Int, completion: @escaping ([Post]) -> Void) {
        guard let user = localUser else {
            completion([])
            return
        }
        
        let request = PostRouter.loadPosts(appId: appId,
                                           offset: offset,
                                           count: count,
                                           userId: user.id,
                                           tokenString: user.token.tokenString)
        
        Alamofire
            .request(request)
            .responseJSON { (dataResponse) in
                
                guard let response = dataResponse.result.value as? [String: Any] else {
                    completion([])
                    return
                }
                
                let success = !(response["error"] as! Bool)
                if success {
                    let jsonPosts = response["posts"] as! [[String: Any]]
                    let posts = jsonPosts.map { Post(with: $0) }
                    completion(posts)
                } else {
                    debugPrint(response)
                    completion([])
                }
                
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

// MARK: - Feed Routing

enum PostRouter: URLRequestConvertible {
    
    private static let baseURLString = "\(Constants.baseApiServicePath)/posts"
    
    case loadPosts(appId: Int, offset: Int, count: Int, userId: Int, tokenString: String)
    
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
        case let .loadPosts(appId, offset, count, userId, tokenString):
            let params: [String : Any] = [
                "token": tokenString,
                "app_id": appId,
                "offset": offset,
                "count": count,
                "user_id": userId
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with:params)
        }
        return urlRequest
    }
}
