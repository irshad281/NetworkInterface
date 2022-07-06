public struct NetworkInterface {
    public init() { }
    static var logsEnabled = false
    public static func enableNetworkLogs(_ enable: Bool) {
        NetworkInterface.logsEnabled = enable
    }
}
