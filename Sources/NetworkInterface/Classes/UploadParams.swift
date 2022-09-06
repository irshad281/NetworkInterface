//
//  UploadParams.swift
//  
//
//  Created by Irshad Ahmad on 06/09/22.
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

public struct UploadParams {
    let key: String
    let value: Any
    let type: UploadFieldType
    var fileName: String?
    var mimeType: String?
    
    public init(key: String, value: Any, type: UploadFieldType, fileName: String? = nil, mimeType: String? = nil) {
        self.key = key
        self.value = value
        self.type = type
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

public enum UploadFieldType: String, CaseIterable {
    case text
    case file
}

public extension Collection where Iterator.Element == UploadParams {
    var requestBody: Data {
        var bodyData = Data()
        let lineBreak = "\r\n"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        for param in self {
            switch param.type {
            case .text:
                if let value = param.value as? String {
                    bodyData.append("--\(boundary + lineBreak)")
                    bodyData.append("Content-Disposition:form-data; name=\"\(param.key)\"")
                    bodyData.append("\r\n\r\n\(value + lineBreak)")
                }
                
            case .file:
                if let imageData = param.value as? Data {
                    let filename = param.fileName ?? "\(String(UUID().uuidString.prefix(8))).jpg"
                    let paramName = "image"
                    let mime = param.mimeType ?? "image/*"
                    bodyData.append("--\(boundary + lineBreak)")
                    bodyData.append("Content-Disposition:form-data; name=\"\(paramName)\"")
                    bodyData.append("; filename=\"\(filename)\"\(lineBreak)")
                    bodyData.append("Content-Type: \(mime + lineBreak + lineBreak)")
                    bodyData.append(imageData)
                    bodyData.append(lineBreak)
                }
            }
        }
        
        bodyData.append("--\(boundary)--\(lineBreak)")
        
        return bodyData
    }
    
    func valueForKey(_ key: String) -> Any? {
        first(where: { $0.key == key })?.value
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
