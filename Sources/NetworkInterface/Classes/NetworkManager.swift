//  NetworkManager.swift
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
import Combine

// MARK: - NetworkManager

public extension NetworkInterface {
    
    /// This method is to make your serve call from Request and return a `Decodable Element`.
    public static func performRequest<Element: Decodable>(_ request: Request)
    -> Future<Element, RequestError>
    {
        Future<Element, RequestError> { promise in
            guard let httpRequest = request.asHttpRequest() else {
                return promise(.failure(.invalidRequest))
                
            }
            URLSession.shared.dataTask(with: httpRequest) { responseData, headerResponse, error in
                if let response = headerResponse as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if NetworkInterface.logsEnabled { debugPrint("Status Code: \(statusCode)") }
                }
                DispatchQueue.main.async {
                    return promise(NetworkInterface.decodeData(responseData: responseData, error: error))
                }
            }.resume()
        }
    }
    
    /// Print the response from server
    /// - Parameter data: Response Data in `binary`
    static func logResponse(from data: Data) {
        if let json = try? JSON(data: data) {
            debugPrint(json)
        } else if let data = String(data: data, encoding: .utf8) {
            debugPrint(data)
        }
    }
}
