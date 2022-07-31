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
