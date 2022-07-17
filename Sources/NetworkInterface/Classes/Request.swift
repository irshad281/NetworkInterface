//  Request.swift
//  NetworkInterface
//
//  Created by Irshad Ahmad on 10/03/22.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public protocol Request {
    /// HTTP Methods
    var method: HTTPMethod { get }
    
    /// Base `URL` for request
    var baseURLString: String { get }
    
    /// End Point for `URL` request
    var endPoint: String { get }
    
    /// HTTP Request Body
    func body() throws -> Data?
    
    /// HTTP Request Headers
    func headers() -> [String: String]
}

extension Request {
    
    private var finalUrl: String { baseURLString + endPoint }
    
    @discardableResult
    func asHttpRequest() -> URLRequest? {
        var urlString = finalUrl
        if urlString.contains(" ") {
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        guard let url = URL(string: urlString) else {
            
            return nil
        }
        if NetworkInterface.logsEnabled {
            debugPrint("Request URL -> \(finalUrl)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try? body()
        request.allHTTPHeaderFields = headers()
        
        return request
    }
}

public enum RequestError: Error {
    case unknown
    case invalidRequest
    case decodingError(error: Error)
    case requestError(error: Error)
    case customError(errorStr: String)
    case errorWith(data: Data)
}
