# NetworkInterface
It's a advance NetworkInterface to execute your web services, it developed over combine framework, This single class is itself enough to fulfill all your web services requrements. You can easily modularize your web-serices.

# Installation
## Swift Package Manager
Go to `File | Swift Packages | Add Package Dependency...` in Xcode and search for "UtilityPackage".
```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/irshad281/NetworkInterface")
    ],
)
```
## Request
You make make seperate request for your modules like this.
```swift
enum AuthRequest: Request {
    
    // MARK: - AuthRequest Request -
    case login(model: LoginParams)
    case signup(model: SignupParams)
    case userDetail(id: Int)
    case userArticles(id: Int)
    case search(q: String, size: Int, page: Int)
    
    // MARK: -
    var method: HTTPMethod {
        switch self {
        case .userDetail, .userArticles, .search:
            return .get
            
        default:
            return .post
        }
    }
    
    var baseURLString: String { App.url }
    
    var endPoint: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/signup"
        case .userDetail(let id):
            return "/users/\(id)"
        case .search(let query, let size, let page):
            return "/news/search?q=\(query)&size=\(size)&page=\(page)"
        case .userArticles(let id):
            return "/users/article/\(id)"
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .login(let params):
            return try? params.asRequestBody()
        case .signup(let params):
            return try? params.asRequestBody()
        case .search, .detail, .relatedArticles:
            return nil
        }
    }
    
    func headers() -> Headers { App.shared.headers }
        
}
```

After creating your `request`, you can make your `service` implementation like this 

```swift
struct AuthService {
    static func loginWith(params: LoginParams) -> Future<LoginModel, RequestError> {
        NetworkManager.performRequest(AuthRequest.login(model: params))
    }
    
    static func signupWith(params: SignupParams) -> Future<SignupModel, RequestError> {
        NetworkManager.performRequest(NewsRequest.signup(model: params))
    }
    
    static func getUserDetailsWith(id: Int) -> Future<UserDetailModel, RequestError> {
        NetworkManager.performRequest(NewsRequest.userDetail(id: id))
    }
}
```
