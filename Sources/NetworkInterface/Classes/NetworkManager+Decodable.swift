//
//  NetworkManager+Decodable.swift
//  NetworkInterface
//
//  Created by Irshad Ahmad on 23/03/22.
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

public extension NetworkInterface {
    
    static func decodeData<Element: Decodable>(responseData: Data?, error: Error?) -> Result<Element, RequestError>{
        if let data = responseData {
            do {
                let result = try JSONDecoder.dateDecoder.decode(Element.self, from: data)
                return .success(result)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                return .failure(.decodingError(error: DecodingError.dataCorrupted(context)))
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                return .failure(.errorWith(data: data))
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                return .failure(.decodingError(error: DecodingError.valueNotFound(value, context)))
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("CodingPath:", context.codingPath)
                return .failure(.decodingError(error: DecodingError.typeMismatch(type, context)))
            } catch let error{
                print("error: ", error.localizedDescription)
                return .failure(.decodingError(error: error))
            }
            
        } else if let error = error {
            return .failure(.requestError(error: error))
        } else {
            return .failure(.unknown)
        }
    }
    
}
