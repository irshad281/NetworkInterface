# NetworkInterface
It's a advance NetworkInterface to execute your web services, it developed over combine framework, This single class is itself enough to fulfill all your web services requrements. You can easily modularize your web-serices.

# Installation
## Swift Package Manager
Go to `File | Swift Packages | Add Package Dependency...` in Xcode and search for "NetworkInterface".
```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/irshad281/NetworkInterface")
    ],
)
```

# Enable/Disable Networks logs

```swift
NetworkInterface.enableNetworkLogs(true)
````

# Request
Define your request route by confirming to `Request` protocol below is an example.

```swift
enum AuthRequest: Request {
    
    // MARK: - Request
    case login(model: LoginParams)
    
    // MARK: -
    var method: HTTPMethod {
        .post
    }
    
    var baseURLString: String { App.url }
    
    var endPoint: String {
        return "/login"
    }
    
    func body() throws -> Data? {
        try? params.asRequestBody()
    }
    
    func headers() -> Headers { App.headers }
        
}
```
# Service Layer

After defininig your `Request`, create your seperate `Service Layer` like this.

```swift
struct AuthService {
    static func loginWith(params: LoginParams) -> Future<LoginModel, RequestError> {
        NetworkManager.performRequest(AuthRequest.login(model: params))
    }
}
```

# Service Chaining 
Chain your multiple `Services` into single service becomes super easy by using `NetworkInterface`

```swift
let service1 = UserService.getUserDetails()
let service2 = UserService.getUserFeed()
let service3 = UserService.getUserArticles()

let services = Publishers.Zip(service1, service2, service3)
        
services.sink { state in
    switch state {
    case .finished:
        // Task is finished.
    case .failure(let error):
        print(error)
    }
} receiveValue: { result1, result2, result3 in
    // result1 = response of service1
    // result2 = response of service2
    // result3 = response of service3
    // do your stuff with the response here.
}.store(in: &cancellables)
```

# Upload File Request
Here is the structure of UploadParams. first you need to make your parameters using `UploadParams`.

```swift
public struct UploadParams {
    let key: String
    let value: Any
    let type: UploadFieldType
    var fileName: String?
    var mimeType: String?
}
```
`key` = key name in which you want to send data.

`value` = it can be `String` or `Data` which you want to send.

`type` = for normal parameter use `.text` and for file/image parameter user `.file`.

if type is `.file` then you need to send `fileName` and `mimeType` too. 

Here is an example

```swift
var params: [UploadParams] = [
    UploadParams(key: "username", value: username, type: .text),
    UploadParams(key: "image", value: imageData, type: .file, fileName: imageName, mimeType: "image/*")
]
````  

Once your UploadParams are ready you need to create your Upload Request Like this.

```swift
import NetworkInterface

enum UserRequest: Request {
    case updateUserWithImage(params: [UploadParams])
    
    var method: HTTPMethod { .put }
    
    var baseURLString: String { App.baseUrl }
    
    var endPoint: String { "users" }
    
    func body() throws -> Data? {
        switch self {
        case .updateUserWithImage(let params):
            return params.requestBody
        }
    }
    
    func headers() -> Headers {
        switch self {
        case .updateUserWithImage(let params):
            let username = params.valueForKey(.username) as? String ?? ""
            var headers = App.headers(username: username)
            headers[.contentType] = "multipart/form-data; boundary=\(UploadParams.boundary)"
            return headers
        }
    }
}

``` 
# Example App 
Checkout the sample code from [Example App](https://github.com/irshad281/ExampleApp)
