//
//  HTTPHeaders.swift
//  
//
//  Created by Irshad Ahmad on 22/08/22.
//

import Foundation

public extension String {
    /// The `Accept` Header
    static let accept = "Accept"
    
    /// The `Content-Type` Header
    static let contentType = "Content-Type"
    
    /// The `application/json` Header
    static let applicationJSON = "application/json"
    
    /// The `Form-Data` Header
    static let multipartFormData = "multipart/form-data"
    
    /// The `Authorization` Header
    static let authorization = "Authorization"
    
    /// The `Cookie` Header
    static let cookie = "Cookie"
    
    /// The `Accept-Charset` Header
    static let acceptCharset = "Accept-Charset"
    
    /// The `Accept-Encoding` Header
    static let acceptEncoding = "Accept-Encoding"
    
    /// The `Accept-Language` Header
    static let acceptLanguage = "Accept-Language"
    
    /// The `Host` Header
    static let host = "Host"
    
    /// The `Origin` Header
    static let origin = "Origin"
    
    /// The `User-Agent` Header
    static let userAgent = "User-Agent"
}
