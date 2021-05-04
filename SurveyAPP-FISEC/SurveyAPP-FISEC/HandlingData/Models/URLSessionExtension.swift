//
//  URLSessionExtension.swift
//  SurveyAPP-FISEC
//
//  Created by Radovan Klembara on 29/03/2021.
//

import Combine
import Foundation
import Defaults

/// Represents HTTP methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

extension URLSession {
    /// Sends HTTP request to server url with certain type of method, headers and HTTP body
    /// - Parameters:
    ///   - method: represents what type of method should be send
    ///   - url: url address of destination
    ///   - headers: HTTP headers
    ///   - body: HTTP body
    /// - Returns: body of HTTP answer or error
    static func requestPublisher<Upstream: Encodable>(
        method: HTTPMethod = .get,
        url: URL,
        headers: [String: String] = ["Content-Type":"application/json; charset=utf-8"],
        body: Upstream?
    ) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        var hdrs = headers
        if let a = Defaults[.token] {
            let h = "Bearer \(a)"
            hdrs.updateValue(h, forKey: "Authorization") 
        }
        assert(method != .get || body == nil, "Body is not allowed in GET")
        request.httpMethod = method.rawValue
        hdrs.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                if let response = output.response as? HTTPURLResponse, response.statusCode != 200 {
                    switch response.statusCode {
                    case 404:
                        throw HTTPError.notFound
                    case 401:
                        throw HTTPError.unauthorized
                    case 409:
                        throw HTTPError.conflict
                    case 421:
                        throw HTTPError.misdirected
                    default:
                        throw HTTPError.statusCode
                    }
                }
                return output.data 
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Sends HTTP request to server url with certain type of method, headers and HTTP body
    /// - Parameters:
    ///   - method: represents what type of method should be send
    ///   - url: url address of destination
    ///   - headers: HTTP headers
    ///   - body: HTTP body
    ///   - resultType: type of what is expected in HTTP answer
    /// - Returns: decoded body of HTTP answer
    static func requestPublisher<Upstream: Encodable, Downstream: Decodable>(
        method: HTTPMethod = .get,
        url: URL,
        headers: [String: String] = ["Content-Type":"application/json; charset=utf-8"],
        body: Upstream?,
        resultAs resultType: Downstream.Type = Downstream.self
    ) -> AnyPublisher<Downstream, Error> {
        
        return requestPublisher(method: method, url: url, headers: headers, body: body)
            .decode(type: resultType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Sends HTTP request to server url with certain type of method, headers and HTTP body
    /// - Parameters:
    ///   - method: represents what type of method should be send
    ///   - url: url address of destination
    ///   - headers: HTTP headers
    ///   - resultAs: type of what is expected in HTTP answer
    /// - Returns: decoded body of HTTP answer
    static func requestPublisher<Downstream: Decodable>(
        method: HTTPMethod = .get,
        url: URL,
        headers: [String: String] = ["Content-Type":"application/json; charset=utf-8"],
        resultAs: Downstream.Type = Downstream.self
    ) -> AnyPublisher<Downstream, Error> {
        requestPublisher(method: method, url: url, headers: headers, body: Int?.none, resultAs: resultAs)
    }
    
    /// Sends HTTP request to server url with certain type of method, headers and HTTP body
    /// - Parameters:
    ///   - method: represents what type of method should be send
    ///   - url: url address of destination
    ///   - headers: HTTP headers
    /// - Returns: body of HTTP request
    static func requestPublisher(
        method: HTTPMethod = .get,
        url: URL,
        headers: [String: String] = ["Content-Type":"application/json; charset=utf-8"]
    ) -> AnyPublisher<Data, Error> {
        requestPublisher(method: method, url: url, headers: headers, body: Int?.none)
    }
}
